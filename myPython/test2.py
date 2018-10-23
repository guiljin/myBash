import threading
import logging
import time

logging.basicConfig(level=logging.DEBUG, format='(%(threadName)-10s) %(message)s', )
lists = ['192.168.1.1', '192.168.1.2']


class MyThread(threading.Thread):
    def __init__(self, ip):
        threading.Thread.__init__(self)
        self.ip = ip

    def run(self):
        logging.debug("%s start!" % self.ip)
        time.sleep(5)
        logging.debug('%s Done!' % self.ip)


if __name__ == "__main__":
    for ip in lists:
        t = MyThread(ip)
        t.start()
    for t in threading.enumerate():
        if t is threading.currentThread():
            continue
        t.join()

    logging.debug('Done!')
