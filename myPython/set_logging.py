import logging
# CRITICAL = 50
# FATAL = CRITICAL
# ERROR = 40
# WARNING = 30
# WARN = WARNING
# INFO = 20
# DEBUG = 10
# NOTSET = 0
logging.basicConfig(
    level=logging.WARN,
    format='%(asctime)s %(levelname)s %(message)s',
)

logging.debug("Debug message")
logging.info("Info message")
logging.warn("Warn message")
logging.error("Error message")
logging.fatal("Fatal message")