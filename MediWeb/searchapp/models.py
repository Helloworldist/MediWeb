from django.db import models

# Create your models here.

class List(models.Model):
	name = models.CharField(max_length = 20)
	X = models.CharField(max_length = 20)
	Y = models.CharField(max_length = 20)