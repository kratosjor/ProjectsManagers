# Generated by Django 5.1.6 on 2025-03-18 14:28

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('list', '0008_comentario'),
    ]

    operations = [
        migrations.AlterField(
            model_name='comentario',
            name='fecha_creacion',
            field=models.DateTimeField(auto_now_add=True),
        ),
    ]
