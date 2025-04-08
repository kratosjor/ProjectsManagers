from django.apps import AppConfig


class ListConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'list'

     # Aquí importamos las señales para que se registren