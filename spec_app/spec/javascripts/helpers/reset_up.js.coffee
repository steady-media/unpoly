afterEach ->
  console.debug('--- Resetting Unpoly after example ---')
  up.motion.finishAll()
  up.reset()
  $('.up-error').remove()
  console.debug('--- Unpoly was reset after example ---')
