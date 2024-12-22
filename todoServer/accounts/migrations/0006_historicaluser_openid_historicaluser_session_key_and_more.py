# Generated by Django 5.0 on 2024-12-22 05:18

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('accounts', '0005_alter_historicaluserfeedback_status_and_more'),
    ]

    operations = [
        migrations.AddField(
            model_name='historicaluser',
            name='openid',
            field=models.CharField(blank=True, db_index=True, max_length=100, null=True, verbose_name='微信 OpenID'),
        ),
        migrations.AddField(
            model_name='historicaluser',
            name='session_key',
            field=models.CharField(blank=True, max_length=100, null=True, verbose_name='微信 SessionKey'),
        ),
        migrations.AddField(
            model_name='historicaluser',
            name='unionid',
            field=models.CharField(blank=True, db_index=True, max_length=100, null=True, verbose_name='微信 UnionID'),
        ),
        migrations.AddField(
            model_name='user',
            name='openid',
            field=models.CharField(blank=True, max_length=100, null=True, unique=True, verbose_name='微信 OpenID'),
        ),
        migrations.AddField(
            model_name='user',
            name='session_key',
            field=models.CharField(blank=True, max_length=100, null=True, verbose_name='微信 SessionKey'),
        ),
        migrations.AddField(
            model_name='user',
            name='unionid',
            field=models.CharField(blank=True, max_length=100, null=True, unique=True, verbose_name='微信 UnionID'),
        ),
    ]
