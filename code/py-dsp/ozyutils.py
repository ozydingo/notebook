import numpy as np
import scipy as sp
import wave
import sys
import os

def hello(name="ozydingo"):
	print "Hello, %s" % (name)

def build_coords(*vecs):
	coords = numpy.empty(map(len,vecs)+[len(vecs)])
	for ii in xrange(len(vecs)):
		s = np.hstack((len(vecs[ii]), np.ones(len(vecs)-ii-1)))
		v = vecs[ii].reshape(s)
		coords[...,ii] = v
	return coords

def mcoords(shape):
	ind = [slice(0,n) for n in shape]
	return np.mgrid[ind].transpose(np.roll(np.arange(len(shape)+1),-1))
