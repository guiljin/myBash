#!/bin/env python


class Student(object):
    @property
    def name(self):
        return self._name
    @name.setter
    def name(self, name):
        self._name = name


s = Student()
s.name = "Darren"
print(s.name)