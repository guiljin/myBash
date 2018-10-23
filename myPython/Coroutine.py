# coding:utf-8
import time


def consumer():
    r = ''
    while True:
        n = yield r
        if not n:
            return
        print('[CONSUMER] Consuming %s...' % n)
        time.sleep(1)
        r = '200 OK'


def produce(c):
    c.next()
    n = 0
    while n < 5:
        n = n + 1
        print('[PRODUCER] Producing %s...' % n)
        rp = c.send(n)  # n直接作为yield的返回值跳过yield继续执行至下次yield r，r作为send的返回值
        print('[PRODUCER] Consumer return: %s' % rp)
    c.close()


if __name__ == '__main__':
    c = consumer()
    produce(c)
