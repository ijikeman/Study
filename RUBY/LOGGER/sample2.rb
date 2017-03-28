require 'logger'

logger = Logger.new(STDOUT)
logger.level = Logger::WARN
logger.progname = 'Sample2'

logger.debug('Creating debug')
logger.info('Creating info')
logger.warn('Creating warn')
