require 'logger'

log = Logger.new('/tmp/log')

log.debug('debug')
log.info('info')
log.warn('warn')
log.error('error')
log.fatal('fatal')
log.unknown('='*80)
log.level=Logger::INFO
log.debug('debug')
log.info('info')
log.warn('warn')
log.error('error')
log.fatal('fatal')
log.unknown('='*80)
log.level=Logger::FATAL
log.debug('debug')
log.info('info')
log.warn('warn')
log.error('error')
log.fatal('fatal')
log.unknown('+'*80)
