from django.shortcuts import render, redirect, get_object_or_404
from .models import *
from .forms import *
from django.views.generic.edit import UpdateView
from django.views.generic import DeleteView
from django.urls import reverse_lazy
from django.db.models import Sum
from django.contrib.auth.forms import AuthenticationForm
from django.contrib.auth import login, logout
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.http import JsonResponse
from django.http import HttpResponseForbidden
import re




###################################

# VISTA HOME

###################################

@login_required
def home(request):
    usuario = request.user

    # Verifica si el usuario tiene el cargo de 'PROJECT MANAGER'
    if usuario.cargo == "PROJECT MANAGER":
        # Filtra las tareas creadas por el PROJECT MANAGER
        tareas = Tarea.objects.filter(creador=usuario).select_related('proyecto').order_by('fecha_inicio')
    else:
        # Filtra las tareas si no es PROJECT MANAGER (puedes personalizar este caso también)
        tareas = Tarea.objects.filter(disenadores=usuario).select_related('proyecto').order_by('fecha_inicio')

    # Agregar las opciones de estado al contexto
    estado_choices = dict(Tarea.ESTADOS_TAREA)
    
    return render(request, 'list/home.html', {'tareas': tareas, 'estado_choices': estado_choices})

###################################

# VISTAR CREAR PROYECTOS

###################################

@login_required
def crear_proyecto(request):
    
    disenador = Disenador.objects.get(username=request.user.username)
    
    if disenador.cargo != 'PROJECT MANAGER':
        messages.error(request, "No tienes permisos para crear proyectos.")
        return redirect('home')
    
    form = ProyectoForm()
    
    if request.method == 'POST':
        form = ProyectoForm(request.POST)
        if form.is_valid():
            form.save()
            return redirect('detalle_proyecto', proyecto_id=form.instance.id)
    else:
        form = ProyectoForm()
        
    
    
    return render(request, 'list/crear_proyecto.html', {'form': form})

###################################

# VISTA agregar tareas

###################################


@login_required
def agregar_tarea(request, proyecto_id):
    disenador = Disenador.objects.get(username=request.user.username)
    
    if disenador.cargo != 'PROJECT MANAGER':
        messages.error(request, "No tienes permisos para agregar tareas.")
        return redirect('home')
    
    proyecto = get_object_or_404(Proyecto, id=proyecto_id)
    horas_estimadas_final = 0

    if request.method == 'POST':
        form = TareaForm(request.POST, proyecto=proyecto)
        if form.is_valid():
            tarea = form.save(commit=False)
            tarea.creador = request.user
            tarea.proyecto = proyecto
            tarea.fecha_inicio = proyecto.fecha_inicio
            tarea.fecha_fin = proyecto.fecha_fin

            # Calcula las horas estimadas antes de guardar
            tipo_tarea = tarea.tipo_tarea
            cantidad_graficos = tarea.cantidad_graficos
            estimado_por_tipo = dict(Tarea.ESTIMADO_TAREA).get(tipo_tarea, 0)
            horas_estimadas_final = cantidad_graficos * estimado_por_tipo
            tarea.horas_estimadas = horas_estimadas_final

            # Guardar la tarea para asignarle un id antes de acceder a las relaciones de muchos a muchos
            tarea.save()  # Guarda la tarea primero
            form.save_m2m()  # Guarda las relaciones muchos a muchos

            # Ahora que la tarea está guardada, verificamos la disponibilidad
            horas_totales_disponibles = 0
            for disenador in tarea.disenadores.all():
                horas_totales_disponibles += disenador.disponibilidad

            # Verificar si la disponibilidad es suficiente y no excede el límite de horas semanales
            if horas_totales_disponibles < tarea.horas_estimadas:
                messages.error(request, "No hay suficiente disponibilidad para esta tarea.")
                tarea.delete()  # Elimina la tarea si no hay disponibilidad suficiente
                return redirect('agregar_tarea', proyecto_id=proyecto_id)

            # Verificar si las horas de la tarea exceden las 40 horas semanales
            if horas_estimadas_final > 40:
                messages.error(request, "La tarea no puede exceder las 40 horas semanales.")
                tarea.delete()  # Elimina la tarea si excede el límite
                return redirect('agregar_tarea', proyecto_id=proyecto_id)

            return redirect('detalle_proyecto', proyecto_id=proyecto_id)
    else:
        form = TareaForm(proyecto=proyecto)

    return render(request, 'list/agregar_tarea.html', {
        'form': form,
        'proyecto': proyecto,
        'horas_estimadas_final': horas_estimadas_final
    })


###################################

# VISTA PROYECTOS_SUPERVISOR

###################################


@login_required
def proyectos_supervisor(request):
    disenador = Disenador.objects.get(username=request.user.username)
    
    if disenador.cargo != 'SUPERVISOR':
        messages.error(request, "Solo Supervisores pueden ver proyectos de su equipo.")
        return redirect('home')
    
    sudordinados = disenador.subordinados.all() # Obtiene los subordinados
    proyectos = Proyecto.objects.filter(encargado__in=sudordinados)  # Filtra los proyectos
    
    return render(request, 'list/proyectos_supervisor.html', {'proyectos': proyectos})



###################################

# VISTA para que el supervisor reasgine tareas

###################################


@login_required
def asignar_tarea_supervisor(request, proyecto_id):
    disenador = Disenador.objects.get(username=request.user.username)

    if disenador.cargo != 'SUPERVISOR':
        return redirect('home')  # Solo supervisores pueden asignar tareas

    proyecto = Proyecto.objects.get(id=proyecto_id)
    form = TareaForm(request.POST or None)
    
    if form.is_valid():
        tarea = form.save(commit=False)
        tarea.proyecto = proyecto
        tarea.disenador = form.cleaned_data['disenador']  # Asigna el diseñador de la tarea
        tarea.save()
        return redirect('proyectos_supervisor')
    
    return render(request, 'list/asignar_tarea_supervisor.html', {'form': form, 'proyecto': proyecto})


###################################

# VISTA editar tareas

###################################


class EditarTarea(UpdateView):
    model = Tarea
    template_name = "list/editar_tarea.html"
    fields = ['tipo_tarea', 'descripcion', 'estado', 'fecha_inicio', 'fecha_fin', 'cantidad_graficos', 'disenadores', 'horas_manuales']

    def form_valid(self, form):
        print(f"Campos del formulario: {form.cleaned_data}")
        tarea = form.save(commit=False)
        tarea.save()
        tarea.verificar_disponibilidad()
        return super().form_valid(form)

    def get_success_url(self):
        return reverse_lazy("detalle_proyecto", kwargs={"proyecto_id": self.object.proyecto.id})



    
    
class EliminarTarea(DeleteView):
    model = Tarea
    template_name = "list/eliminar_tarea.html"
    
    success_url = reverse_lazy("detalle_proyecto")


###################################

# VISTA detalle proyecto

###################################

@login_required
def detalle_proyecto(request, proyecto_id):
    proyecto = get_object_or_404(Proyecto, id=proyecto_id)
    tareas = Tarea.objects.filter(proyecto=proyecto)
    
    return render(request, 'list/detalle_proyecto.html', {'proyecto': proyecto, 'tareas': tareas})


###################################

# VISTA lista de proyectos

###################################

@login_required
def lista_proyectos(request):
    proyectos = Proyecto.objects.all()
    return render(request, 'list/lista_proyectos.html', {'proyectos': proyectos})


###################################

# VISTA lista de proyectos

###################################


class EditarProyecto(UpdateView):
    model = Proyecto
    template_name = "list/editar_proyecto.html"
    fields = '__all__'
    success_url = reverse_lazy("lista_proyectos")
    
    
class EliminarProyecto(DeleteView):
    model = Proyecto
    template_name = "list/eliminar_proyecto.html"
    
    success_url = reverse_lazy("lista_proyectos")
    
    
class EliminarTarea(DeleteView):
    model = Tarea
    template_name = "list/eliminar_tarea.html"
    
    def get_success_url(self):
        proyecto_id = self.object.proyecto.id
        return reverse_lazy('detalle_proyecto', kwargs={'proyecto_id':proyecto_id})
    
    

###################################

# VISTA - metricas departamento

###################################

@login_required
def proyectos_totales_departamento(request):
    # Obtener todos los proyectos y las horas estimadas de cada tarea asociada
    proyectos_con_horas = (
        Proyecto.objects
        .annotate(total_horas_estimadas=Sum('tareas__horas_estimadas'))
        .all()
    )

    # Calcular el total de horas estimadas de todos los proyectos
    total_horas_totales = proyectos_con_horas.aggregate(Sum('total_horas_estimadas'))['total_horas_estimadas__sum'] or 0

    return render(request, 'list/proyectos_totales_departamento.html', {
        'proyectos_con_horas': proyectos_con_horas,
        'total_horas_totales': total_horas_totales
    })



#########################################

# VISTA HOME DEL DISEÑADOR CON SU LISTA DE PROYECTOS

#########################################
#
#
#def home_disenador(request, disenador_id):
#    disenador = Disenador.objects.get(id=disenador_id)
#    
#    # Obtener todas las tareas relacionadas con el diseñador
#    tareas = disenador.tareas.all()  # Usamos 'tareas' debido al 'related_name' en ManyToManyField
#    
#    # Obtener los proyectos asociados a esas tareas
#    proyectos = set(tarea.proyecto for tarea in tareas)
#    
#    return render(request, 'list/home_disenador.html', {'disenador': disenador, 'proyectos': proyectos})
#
#
#########################################

# VISTA - cambiar estado tarea

#########################################

def cambiar_estado_tarea(request, tarea_id):
    tarea = get_object_or_404(Tarea, id=tarea_id)

    if request.method == 'POST':
        nuevo_estado = request.POST.get('estado')
        
        # Verificar si el estado es válido
        if nuevo_estado in dict(Tarea.ESTADOS_TAREA):
            tarea.estado = nuevo_estado
            tarea.save()

            # Redirigir al usuario a la página principal (o cualquier otra vista que desees)
            return redirect('home')  # Ajusta la URL a la que quieras redirigir

    # Si no se ha enviado una solicitud POST, simplemente mostrar la tarea
    return render(request, 'list/home.html', {'tareas': Tarea.objects.all()})


#########################################

# VISTA HOME DEL DISEÑADOR CON SU LISTA DE PROYECTOS

#########################################


def login_usuario(request):
    if request.method == "POST":
        form = AuthenticationForm(request, data=request.POST)
        if form.is_valid():
            usuario = form.get_user()
            login(request, usuario)
            
            next_url = request.POST.get('next') or request.GET.get('next') or 'home'
            return redirect(next_url)
        else:
            messages.error(request, "Usuario o contraseña incorrectos.")
    else:
        form = AuthenticationForm()

    return render(request, 'list/login.html', {'form': form, 'next': request.GET.get('next', '')})



def registro_usuario(request):
    if request.method == "POST":
        form = DisenadorForm(request.POST)
        if form.is_valid():
            # Guardamos el usuario sin confirmar para agregar el correo como username
            user = form.save(commit=False)
            user.username = user.correo  # Usamos el correo como username
            user.save()  # Guardamos el usuario en la base de datos

            # Iniciamos sesión automáticamente con el nuevo usuario
            login(request, user)

            return redirect('home')  # Redirigimos a la página de inicio

    else:
        form = DisenadorForm()

    return render(request, "list/registro_usuario.html", {'form': form})



@login_required
def logout_usuario(request):
    logout(request)
    return redirect('home')


#########################################

# VISTA PARA EDITAR USUARIOS y lista usuario

#########################################

@login_required
def editar_usuario(request, user_id):
    # Verificar si el usuario autenticado es un administrador
    if request.user.cargo != 'ADMINISTRADOR':
        messages.error(request, "No tienes permiso para realizar esta acción.")
        return redirect('lista_usuarios')  # Redirigir al inicio

    usuario = get_object_or_404(Disenador, id=user_id)

    if request.method == 'POST':
        form = DisenadorForm(request.POST, instance=usuario)
        if form.is_valid():
            form.save()
            return redirect('lista_usuarios')  # Redirigir a la lista de usuarios después de guardar cambios
    else:
        form = DisenadorForm(instance=usuario)

    return render(request, 'list/editar_usuario.html', {'form': form, 'usuario': usuario})


@login_required
def lista_usuarios(request):
    usuarios = Disenador.objects.all()  # O filtra según sea necesario
    return render(request, 'list/lista_usuarios.html', {'usuarios': usuarios})


###################################

# VISTA - AGREGAR COMENTARIO

###################################

@login_required
def agregar_comentario_tarea(request, proyect_id, tarea_id):
    if request.method == "POST":
        tarea = get_object_or_404(Tarea, id=tarea_id)
        contenido = request.POST.get("contenido", "").strip()

        if contenido:
            comentario = Comentario.objects.create(
                tarea=tarea,
                usuario=request.user,  # Verifica que request.user es Disenador
                contenido=contenido
            )
            

            # Verificación para asegurarnos de que el usuario es una instancia de Disenador
            usuario_nombre = comentario.usuario.nombre if hasattr(comentario.usuario, 'nombre') else comentario.usuario.username

            return JsonResponse({
                "usuario": usuario_nombre,  # Usamos el nombre en lugar de username
                "contenido": comentario.contenido,
                "fecha_creacion": comentario.fecha_creacion.strftime("%m-%d-%y %H:%M")
            })
    return JsonResponse({"error": "Solicitud inválida"}, status=400)
    

@login_required
def agregar_comentario_proyecto(request, proyect_id):
    proyecto = get_object_or_404(Proyecto, id=proyect_id)  # obtener el proyecto
    
    if request.method == 'POST':
        form = ComentarioForm(request.POST)
        if form.is_valid():
            comentario = form.save(commit=False)
            comentario.usuario = request.user
            comentario.proyecto = proyecto  # asociar el comentario con el proyecto
            comentario.save()

            # notificar menciones
            for usuario in comentario.menciones.all():
                messages.info(request, f'{usuario.nombre}, te ha mencionado en un comentario.')

            return redirect('detall_proyecto', proyect_id=proyecto.id)

    else:
        form = ComentarioForm()

    return render(request, 'list/agregar_comentario_proyecto.html', {'form': form, 'proyecto': proyecto})



###################################

# VISTA DETALLE TAREA

###################################


@login_required
def detalle_tarea(request, tarea_id):
    tarea = get_object_or_404(Tarea, id=tarea_id)  # Buscar la tarea o mostrar error 404
    
    # 🔹 Depuración: Muestra en la consola la tarea obtenida
    print(f"Tarea encontrada: {tarea}")  
    print(f"Proyecto: {tarea.proyecto.nombre}")  
    print(f"Tipo: {tarea.tipo_tarea}")  
    print(f"Descripción: {tarea.descripcion}")  

    return render(request, 'list/detalle_tarea.html', {'tarea': tarea})
                
###################################

# VISTA ELIMINAR COMENTARIO

###################################


@login_required
def eliminar_comentario(request, comentario_id):
    comentario = get_object_or_404(Comentario, id=comentario_id)

    # Verificar que el usuario sea el autor del comentario o un administrador
    if comentario.usuario == request.user or request.user.is_staff:
        comentario.delete()  # Eliminar el comentario
    else:
        # Si no es el autor o un administrador, no dejar eliminar el comentario
        return redirect('detalle_tarea', tarea_id=comentario.tarea.id)

    return redirect('detalle_tarea', tarea_id=comentario.tarea.id)

###################################

# VISTA OBTENER USUARIOS

###################################


def obtener_usuarios(request):
    usuarios = list(Disenador.objects.values_list('username', flat=True))
    return JsonResponse({"usuarios": usuarios})