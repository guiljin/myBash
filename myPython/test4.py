class A(object):
	def __init__(self):
		self.name = 'Jeremy'

class B(A):
	def __init__(self):
		super(B,self).__init__()
		self.name = 'Jian'

class C(B):
	def __init__(self):
		super(C,self).__init__()
		self.name = 'Zhao'

class D(A):
	def __init__(self):
		super(D,self).__init__()
		self.name = 'Zhao Jian'

class E(C,D,A):
	def __init__(self):
		super(E,self).__init__()
		self.lover = 'Aimee'
		print self.name + " love " + self.lover
e = E()
