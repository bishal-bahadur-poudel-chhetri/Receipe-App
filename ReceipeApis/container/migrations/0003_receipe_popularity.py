# Generated by Django 4.2.6 on 2023-12-21 15:32

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('container', '0002_alter_ingredient_ingredient_url'),
    ]

    operations = [
        migrations.AddField(
            model_name='receipe',
            name='popularity',
            field=models.PositiveIntegerField(default=0),
        ),
    ]
