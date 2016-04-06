afterEach (done) ->
  $('.up-error').remove()
  up.reset().then ->
    console.debug('--- Unpoly was reset after example ---')
    done()
