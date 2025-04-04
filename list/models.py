from django.db import models
from datetime import timedelta
from django.utils import timezone
from django.contrib.auth.models import AbstractUser




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
    horas_manuales = models.BooleanField(default=False)  # Casilla para calcular horas manuales
    horas_reales = models.PositiveIntegerField(null=True, blank=True)
    creador = models.ForeignKey(Disenador, on_delete=models.SET_NULL, null=True, blank=True, related_name='tareas_creadas')

    def calcular_horas_estimadas(self):
        """
        Calcula las horas estimadas en base al tipo de tarea.
        """
        estimado_por_tipo = self.ESTIMADO_TAREA.get(self.tipo_tarea, 0)  # Usar .get() para evitar KeyError
        return estimado_por_tipo * self.cantidad_graficos if estimado_por_tipo else 0

    def verificar_disponibilidad(self):
        """
        Verifica si los diseñadores asignados tienen suficiente disponibilidad.
        """
        horas_totales_disponibles = sum(disenador.disponibilidad for disenador in self.disenadores.all())
        if horas_totales_disponibles < self.horas_estimadas:
            raise ValueError("No hay suficiente disponibilidad de diseñadores.")
        return True

    def ajustar_disponibilidad(self):
        """
        Ajusta la disponibilidad de los diseñadores después de asignar la tarea.
        """
        horas_por_disenador = self.horas_estimadas / self.disenadores.count() if self.disenadores.count() > 0 else 0
        for disenador in self.disenadores.all():
            disenador.disponibilidad -= horas_por_disenador
            disenador.save()

    def revertir_disponibilidad(self):
        """
        Revierte las horas de disponibilidad de los diseñadores cuando la tarea se elimina.
        """
        horas_por_disenador = self.horas_estimadas / self.disenadores.count() if self.disenadores.count() > 0 else 0
        for disenador in self.disenadores.all():
            disenador.disponibilidad += horas_por_disenador
            disenador.save()

    def save(self, *args, **kwargs):
        # Verificar la disponibilidad antes de guardar
        if self.id:  # Solo si es una tarea existente, comprobamos disponibilidad
            tarea_original = Tarea.objects.get(id=self.id)
            if tarea_original.disenadores != self.disenadores or tarea_original.cantidad_graficos != self.cantidad_graficos:
                self.horas_estimadas = self.calcular_horas_estimadas()
                self.verificar_disponibilidad()

        # Si es una nueva tarea, calculamos las horas estimadas
        if not self.id:
            self.horas_estimadas = self.calcular_horas_estimadas()
        
        # Guardar el objeto
        super().save(*args, **kwargs)

        # Ajustar la disponibilidad de los diseñadores después de guardar
        self.ajustar_disponibilidad()

    def delete(self, *args, **kwargs):
        """
        Revierte la disponibilidad de los diseñadores cuando la tarea es eliminada.
        """
        self.revertir_disponibilidad()
        super().delete(*args, **kwargs)

    def __str__(self):
        return f"{self.tipo_tarea} - {self.proyecto.nombre}"



##############################################################################################

####CLASS COMENTARIO

class Comentario(models.Model):
    usuario = models.ForeignKey(Disenador, on_delete=models.CASCADE)#user que comenta
    contenido = models.TextField()
    fecha_creacion = models.DateTimeField(auto_now_add=True)
    proyecto = models.ForeignKey('Proyecto',on_delete=models.CASCADE, related_name='comentarios', null=True, blank=True)
    tarea = models.ForeignKey('Tarea',on_delete=models.CASCADE, related_name='comentarios', null=True, blank=True)
    menciones = models.ManyToManyField(Disenador, related_name='mencionado_en', blank=True)
    
    def detectar_menciones(self, *args, **kwargs):
        super().save(*args, **kwargs)#guarda comentario primero
        self.detectar_menciones() #detectar menciones despues
    