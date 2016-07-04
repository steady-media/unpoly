#afterEach (done) ->
#  up.util.nextFrame ->
#    console.debug('--- Resetting Unpoly after example ---')
#    up.reset().then ->
#
#      console.debug('--- Unpoly was reset after example ---')
#      done()

afterEach ->
  up.reset()
  $('.up-error').remove()
  

