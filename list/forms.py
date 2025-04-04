from django import forms
from .models import *
from django.contrib.auth.forms import UserCreationForm
import datetime
from django.utils.timezone import localdate

##################################################################################################################

class ProyectoForm(forms.ModelForm):
    
    class Meta:
        model = Proyecto
        fields = ['nombre', 'descripcion', 'fecha_inicio', 'fecha_fin', 'estado','creador']
        widgets = {
            'fecha_inicio': forms.DateInput(attrs={'type': 'date'}),
            'fecha_fin': forms.DateInput(attrs={'type': 'date'}),
        }

    def clean_fecha_inicio(self):
        fecha_inicio = self.cleaned_data.get('fecha_inicio')

        if isinstance(fecha_inicio, datetime.datetime):
            fecha_inicio = fecha_inicio.date()

        fecha_actual = localdate()

        if not fecha_inicio:
            raise forms.ValidationError("Debes ingresar una fecha de inicio.")

        if fecha_inicio < fecha_actual:
            raise forms.ValidationError("No puedes seleccionar una fecha de inicio pasada.")

        if fecha_inicio.weekday() in [5, 6]:  # 5 = Sábado, 6 = Domingo
            raise forms.ValidationError("No se permiten proyectos con fecha de inicio en sábado o domingo.")

        return fecha_inicio

    def clean_fecha_fin(self):
        fecha_inicio = self.cleaned_data.get('fecha_inicio')
        fecha_fin = self.cleaned_data.get('fecha_fin')

        if isinstance(fecha_fin, datetime.datetime):
            fecha_fin = fecha_fin.date()

        if not fecha_fin:
            raise forms.ValidationError("Debes ingresar una fecha de finalización.")

        if fecha_inicio and fecha_fin < fecha_inicio:
            raise forms.ValidationError("La fecha de fin no puede ser anterior a la fecha de inicio.")

        if fecha_fin.weekday() in [5, 6]:  # 5 = Sábado, 6 = Domingo
            raise forms.ValidationError("No se permiten proyectos con fecha de finalización en sábado o domingo.")

        return fecha_fin
        
###################################################################################################################
        
class DisenadorForm(UserCreationForm):
    # Aseguramos que el username no esté vacío
    username = forms.CharField(max_length=100, required=False, widget=forms.HiddenInput())

    class Meta:
        model = Disenador
        fields = ["nombre", "correo",'cargo','supervisor']
        
    password1 = forms.CharField(label="Password", widget=forms.PasswordInput)
    password2 = forms.CharField(label="Confirm Password", widget=forms.PasswordInput)

    def clean_username(self):
        # Usamos el correo como username
        return self.cleaned_data['correo']

        
###################################################################################################################

class TareaForm(forms.ModelForm):
    class Meta:
        model = Tarea
        fields = ['tipo_tarea', 'descripcion', 'estado', 'cantidad_graficos', 'disenadores', 'horas_manuales']

        widgets = {
            'fecha_inicio': forms.DateInput(attrs={'type': 'date'}),
            'fecha_fin': forms.DateInput(attrs={'type': 'date'}),
        }
        disenadores = forms.ModelMultipleChoiceField(queryset=Disenador.objects.all(), required=True)
    
    
        
    def __init__(self, *args, **kwargs):
        proyecto = kwargs.pop('proyecto', None) # Obtenemos el proyecto
        super().__init__(*args, **kwargs)
        
        if proyecto:
            #asignamos valores iniciales y deshabilitamos los campos fecha
            self.initial['fecha_inicio'] = proyecto.fecha_inicio
            self.initial['fecha_fin'] = proyecto.fecha_fin
            
    def clean_cantidad_graficos(self):
        cantidad = self.cleaned_data.get('cantidad_graficos')
        if cantidad <= 0:
            raise forms.ValidationError("La cantidad de gráficos debe ser un número entero positivo.")
        return cantidad
            

########################################################################################################################


class EstadoTareaForm(forms.ModelForm):
    class Meta:
        model = Tarea
        fields = ['estado']
        
    # Validamos que el estado sea uno de los estados válidos
    def clean_estado(self):
       estado = self.cleaned_data['estado']
       if estado not in dict(Tarea.ESTADOS_TAREA):
           raise forms.ValidationError("Estado no válido")
       return estado
        
##############################################################################################

####CLASS COMENTARIO

class ComentarioForm(forms.ModelForm):
    class Meta:
        model =  Comentario
        fields = ['contenido']