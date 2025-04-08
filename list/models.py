from django.db import models
from datetime import timedelta
from django.utils import timezone
from django.contrib.auth.models import AbstractUser
from django.contrib.auth import get_user_model
import re



##############################################################################################################

class Proyecto(models.Model):
    ESTADOS = [
        ('PB', 'Pending budget'),
        ('RTS', 'Ready to start'),
        ('C', 'Completed'),
    ]

    nombre = models.CharField(max_length=100)
    descripcion = models.TextField()
    fecha_inicio = models.DateField()
    fecha_fin = models.DateField(null=True, blank=True)
    creador = models.ForeignKey('list.Disenador', on_delete=models.CASCADE, related_name='proyectos_creados')
    estado = models.CharField(max_length=10, choices=ESTADOS, default='RTS')
    
    def calcular_fecha_fin(self):
        """
        Calcula la fecha de finalización en base a las horas estimadas y considerando solo días hábiles (lunes a viernes).
        """
        horas_por_dia = 8  # Máximo de horas que se pueden asignar por día
        horas_restantes = self.horas_estimadas
        fecha_actual = self.fecha_inicio

        # Ajuste de la fecha de inicio si es fin de semana
        while fecha_actual.weekday() >= 5:  # Si es sábado (5) o domingo (6), pasa al lunes
            fecha_actual += timedelta(days=1)

        # Calculando la fecha de finalización basada en las horas estimadas
        while horas_restantes > 0:
            if fecha_actual.weekday() < 5:  # Lunes a viernes
                horas_restantes -= horas_por_dia
            fecha_actual += timedelta(days=1)  # Avanza al siguiente día

        # Ajustamos la fecha al último día hábil antes de que se agoten las horas
        return fecha_actual - timedelta(days=1)

    def save(self, *args, **kwargs):
        if not self.fecha_fin:  # Solo se calcula la fecha de fin si no está definida
            self.fecha_fin = self.calcular_fecha_fin()
        super().save(*args, **kwargs)

    def __str__(self):
        return self.nombre

##############################################################################################################

class Disenador(AbstractUser):
    CARGOS = [
        ('PROJECT MANAGER', 'Encargado de proyecto'),
        ('DISENADOR', 'Diseñador'),
        ('SUPERVISOR', 'Supervisor'),
        ('ADMINISTRADOR','Administrador'),
    ]
    nombre = models.CharField(max_length=100)
    # El campo cargo se utiliza para definir el tipo de diseñador
    cargo = models.CharField(max_length=20, choices=CARGOS, default='DISENADOR')
    correo = models.EmailField(unique=True)  # Evita correos duplicados
    disponibilidad = models.FloatField(default=40)#horas disponibles por semana
    
    # Relación con el supervisor
    supervisor = models.ForeignKey(
        'self', on_delete=models.SET_NULL, null=True, blank=True, related_name="subordinados"
    )

    def __str__(self):
        return f"{self.nombre} - {self.cargo}"

##############################################################################################################



class Tarea(models.Model):
    TIPO_TAREA = [
        ('2D FLOORPLAN', '2D Floorplan'),
        ('3D FLOORPLAN', '3D Floorplan'),
        ('FLOW EQUIPMENT', 'Flow Equipment'),
        ('FLOW HYDRONICS', 'Flow Hydronics'),
        ('EXTERIOR', 'Exterior'),
        ('SITEMAP', 'Sitemap'),
    ]

    ESTADOS_TAREA = [
        ('PENDIENTE', 'Pendiente'),
        ('EN_PROGRESO', 'En progreso'),
        ('REVISION', 'En revisión'),
        ('RECHAZADA', 'Rechazada'),
        ('COMPLETADA', 'Completada'),
    ]
    
    ESTIMADO_TAREA = {
        '2D FLOORPLAN': 2.25,
        '3D FLOORPLAN': 2.75,
        'FLOW EQUIPMENT': 1.25,
        'FLOW HYDRONICS': 3.25,
        'EXTERIOR': 16,
        'SITEMAP': 20,
    }

    proyecto = models.ForeignKey(Proyecto, on_delete=models.CASCADE, related_name="tareas")
    disenadores = models.ManyToManyField(Disenador, related_name="tareas") 
    tipo_tarea = models.CharField(max_length=50, choices=TIPO_TAREA)
    descripcion = models.TextField()
    estado = models.CharField(max_length=20, choices=ESTADOS_TAREA, default='PENDIENTE')
    fecha_inicio = models.DateField()
    fecha_fin = models.DateField()
    cantidad_graficos = models.PositiveIntegerField(default=0)
    horas_estimadas = models.FloatField(null=True, blank=True)
    horas_manuales = models.BooleanField(default=False)
    horas_reales = models.PositiveIntegerField(null=True, blank=True)
    creador = models.ForeignKey(Disenador, on_delete=models.SET_NULL, null=True, blank=True, related_name='tareas_creadas')

    def calcular_horas_estimadas(self):
        estimado_por_tipo = self.ESTIMADO_TAREA.get(self.tipo_tarea, 0)
        return estimado_por_tipo * self.cantidad_graficos if estimado_por_tipo else 0

    def notificar_asignacion(self):
        """ Notifica a los diseñadores recién asignados a la tarea. """
        from .models import Notificacion
        
        for disenador in self.disenadores.all():
            Notificacion.objects.create(
                usuario=disenador,
                tipo='TASK_ASSIGNED',
                mensaje=f"Has sido asignado a la tarea '{self.tipo_tarea}' del proyecto '{self.proyecto.nombre}'",
                relacion_con_tarea=self
            )

    def notificar_cambio_estado(self, estado_anterior):
        """ Notifica sobre cambios de estado de la tarea. """
        from .models import Notificacion
        
        if self.estado != estado_anterior:
            for disenador in self.disenadores.all():
                Notificacion.objects.create(
                    usuario=disenador,
                    tipo='TASK_STATUS_CHANGE',
                    mensaje=f"El estado de la tarea '{self.tipo_tarea}' ha cambiado de {estado_anterior} a {self.estado}",
                    relacion_con_tarea=self
                )

            if self.creador and self.estado in ['RECHAZADA', 'COMPLETADA']:
                tipo_notificacion = 'TASK_REJECTED' if self.estado == 'RECHAZADA' else 'TASK_COMPLETED'
                mensaje = (f"Tu tarea '{self.tipo_tarea}' ha sido rechazada" 
                          if self.estado == 'RECHAZADA' 
                          else f"Tu tarea '{self.tipo_tarea}' ha sido completada")
                
                Notificacion.objects.create(
                    usuario=self.creador,
                    tipo=tipo_notificacion,
                    mensaje=mensaje,
                    relacion_con_tarea=self
                )

    def ajustar_disponibilidad(self):
        """ Ajusta la disponibilidad de los diseñadores asignados restando las horas estimadas. """
        for disenador in self.disenadores.all():
            if self.horas_estimadas and disenador.disponibilidad >= self.horas_estimadas:
                disenador.disponibilidad -= self.horas_estimadas
                disenador.save()

    def notificar_menciones(self):
        """Busca menciones en la descripción y notifica a los usuarios mencionados, incluyendo a los Project Managers."""
        from .models import Notificacion, Disenador
        import re

        menciones = re.findall(r'@(\w+)', self.descripcion)  # Busca @usuario en la descripción
        usuarios_mencionados = Disenador.objects.filter(username__in=menciones)

        # Notificar a los usuarios mencionados
        for usuario in usuarios_mencionados:
            Notificacion.objects.create(
                usuario=usuario,
                tipo='MENCION',
                mensaje=f"Has sido mencionado en la tarea '{self.tipo_tarea}' del proyecto '{self.proyecto.nombre}'",
                relacion_con_tarea=self
            )
        
        # Obtener todos los Project Managers
        project_managers = Disenador.objects.filter(cargo='PROJECT MANAGER')

        # Enviar notificación a los Project Managers
        for manager in project_managers:
            Notificacion.objects.create(
                usuario=manager,
                tipo='MENCION',
                mensaje=f"Has sido mencionado en la tarea '{self.tipo_tarea}' del proyecto '{self.proyecto.nombre}'",
                relacion_con_tarea=self
            )

    def save(self, *args, **kwargs):
        estado_anterior = None
        if self.id:
            estado_anterior = Tarea.objects.get(id=self.id).estado

        super().save(*args, **kwargs)

        self.ajustar_disponibilidad()

        if estado_anterior != self.estado:
            self.notificar_cambio_estado(estado_anterior)

        self.notificar_menciones()  # Asegurar que los mencionados reciban su notificación

##############################################################################################

####CLASS noticaaciobn


class Notificacion(models.Model):
    TIPO_CHOICES = [
        ('TASK_ASSIGNED', 'Tarea asignada'),
        ('TASK_STATUS_CHANGE', 'Cambio de estado de tarea'),
        ('TASK_REJECTED', 'Tarea rechazada'),
        ('TASK_COMPLETED', 'Tarea completada'),
        ('MENCION', 'Mención'),
    ]
    
    usuario = models.ForeignKey('Disenador', on_delete=models.CASCADE)
    mensaje = models.CharField(max_length=255)
    tipo = models.CharField(max_length=50, choices=TIPO_CHOICES)
    leida = models.BooleanField(default=False)
    fecha_creacion = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Notificación para {self.usuario.username}: {self.mensaje}"



##############################################################################################

####CLASS COMENTARIO


class Comentario(models.Model):
    tarea = models.ForeignKey('Tarea', on_delete=models.CASCADE)
    usuario = models.ForeignKey(Disenador, on_delete=models.CASCADE)
    contenido = models.TextField()  # El nombre correcto es "contenido"
    fecha_creacion = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Comentario de {self.usuario.username} en la tarea {self.tarea.nombre}"


    def crear_notificaciones(self):
        # Filtramos los usuarios que recibirán la notificación
        usuarios_relevantes = Disenador.objects.filter(cargo__in=["DISEÑADOR", "ADMINISTRADOR", "PROJECT MANAGER", "SUPERVISOR"])
        # Excluimos al usuario que hizo el comentario
        usuarios_relevantes = usuarios_relevantes.exclude(id=self.usuario.id)
        # Excluimos a los diseñadores que no están asignados a la tarea
        usuarios_relevantes = usuarios_relevantes.filter(tareas=self.tarea)
        # Excluimos a los diseñadores que no están en el mismo proyecto
        usuarios_relevantes = usuarios_relevantes.filter(proyectos=self.tarea.proyecto)
       
        for usuario in usuarios_relevantes:
            # Crear una notificación para cada usuario relevante
            if usuario != self.usuario:  # No enviamos notificación al que hace el comentario
                Notificacion.objects.create(
                    usuario=usuario,
                    mensaje=f'Nuevo comentario en la tarea "{self.tarea.nombre}": {self.texto}',
                    tipo='Comentario',
                    leida=False
                )



        


