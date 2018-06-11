from django.db import models

# Create your models here.

class List(models.Model):
	index = models.IntegerField(default = 1)
	name = models.CharField(max_length = 20)
	X = models.CharField(max_length = 20)
	Y = models.CharField(max_length = 20)
	detailinfo1 = models.TextField(default = '')
	detailinfo2 = models.TextField(default = '')
	detailinfo3 = models.TextField(default = '')
	detailinfo4 = models.TextField(default = '')
	detailinfo5 = models.TextField(default = '')
