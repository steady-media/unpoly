afterEach (done) ->
  up.util.nextFrame ->
    console.debug('--- Resetting Unpoly after example ---')
    up.reset().then ->
      $('.up-error').remove()
      console.debug('--- Unpoly was reset after example ---')
      done()
