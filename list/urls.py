from django.urls import path, include
from list.views import *

urlpatterns = [
    path("",home, name='home'),
    path("crear_proyecto/",crear_proyecto, name='crear_proyecto'),
    #path("registrar_disenador/",registrar_disenador, name='registrar_disenador'),      
    path("home_disenador/<int:disenador_id>/", home, name='home_disenador'),
    path("detalle_proyecto/<int:proyecto_id>/", detalle_proyecto, name='detalle_proyecto'),
    path("agregar_tarea/<int:proyecto_id>/", agregar_tarea, name='agregar_tarea'),
    path("lista_proyectos/", lista_proyectos, name='lista_proyectos'),
    path("proyectos_totales_departamento/", proyectos_totales_departamento, name='proyectos_totales_departamento'),
    path('eliminar_comentario/<int:comentario_id>/', eliminar_comentario, name='eliminar_comentario'),
    path('obtener_usuarios/', obtener_usuarios, name='obtener_usuarios'),
    
    
    #Editar proyecto
    path("editar_proyecto/<int:pk>/", EditarProyecto.as_view(), name='editar_proyecto'),
    path("eliminar_proyecto/<int:pk>/", EliminarProyecto.as_view(), name='eliminar_proyecto'),
    
    
    #Login
    path("login/", login_usuario, name='login_usuario'),
    path("logout/", logout_usuario, name='logout_usuario'),
    path("registro_usuario/", registro_usuario, name='registro_usuario'),
    
    #editar tareas
    path('tarea/editar/<int:pk>/', EditarTarea.as_view(), name='editar_tarea'),
    path('tarea/eliminar/<int:pk>/', EliminarTarea.as_view(), name='eliminar_tarea'),
    path('tareas/<int:tarea_id>/', detalle_tarea, name='detalle_tarea'),
    path('agregar_comentario/tarea/<int:proyect_id>/<int:tarea_id>/', agregar_comentario_tarea, name='agregar_comentario_tarea'),
    path('agregar_comentario/proyecto/<int:proyect_id>/', agregar_comentario_proyecto, name='agregar_comentario_proyecto'),
    
    
   
    path('tarea/<int:tarea_id>/cambiar_estado/', cambiar_estado_tarea, name='cambiar_estado_tarea'),
    path('proyectos_supervisor/<int:proyecto_id>/', proyectos_supervisor, name='proyecto_supervisor'),
    path('asignar_tarea_supervisor/<int:proyecto_id>/', asignar_tarea_supervisor, name='asignar_tarea_supervisor'),
    
    #editar usuario
    path('editar_usuario/<int:user_id>/', editar_usuario, name='editar_usuario'),
    
    path('lista_usuarios/', lista_usuarios, name='lista_usuarios'),
    
    
    #NOTIFICACIONES
    

]