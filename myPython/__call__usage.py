class storage(dict):
    def __setattr__(self, key, value):
        print "__setattr__"
        self[key] = value

    def __getattr__(self, key):
        try:
            print "__getattr__"
            return self[key]
        except KeyError, k:
            return None

    def __delattr__(self, key):
        try:
            print "__delattr__"
            del self[key]
        except KeyError, k:
            return None

    def __call__(self, key):
        try:
            print "__call__"
            return self[key]
        except KeyError, k:
            return None

s = storage()
s.name = "hello"
s.age = 20
s.sex = "male"
print s("name")
print s.name
print s["name"]
del s.name
print s("name")
print s.name
print s["name"]
