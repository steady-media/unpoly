u = up.util

class up.flow.ExtractCascade

  constructor: (candidates, options) ->
    console.debug("Candidates before: %o", candidates)
    @options = u.options(options, humanized: 'selector', layer: 'auto')
    @candidates = u.simplifyArray(candidates)
    console.debug("ExtractCascade with candidates %o (%o)", @candidates, options)
    @plans = u.map @candidates, (candidate, i) =>
      planOptions = u.copy(@options)
      if i > 0
        planOptions.transition = up.flow.config.fallbackTransition
      console.debug("planOptions are %o", planOptions)
      new up.flow.ExtractPlan(candidate, planOptions)

  oldPlan: =>
    @detectPlan('oldExists')

  newPlan: =>
    @detectPlan('newExists')

  matchingPlan: =>
    @detectPlan('matchExists')

  detectPlan: (checker) =>
    u.detect @plans, (plan) -> plan[checker]()

  bestOldSelector: =>
    if plan = @oldPlan()
      plan.selector
    else
      @oldPlanNotFound()

  bestMatchingSteps: =>
    if plan = @matchingPlan()
      console.debug("!!! Found matching plan %o", plan)
      plan.steps
    else
      @matchingPlanNotFound()

  matchingPlanNotFound: =>
    if @newPlan()
      @oldPlanNotFound()
    else
      if @oldPlan()
        message = "Could not find #{@humanized} in response"
      else
        message = "Could not match #{@humanized} in current page and response"
      if @response && @options.inspectResponse
        inspectAction = { label: 'Open response', callback: @options.inspectResponse }
      up.fail(["#{message} (tried %o)", @candidates], action: inspectAction)

  oldPlanNotFound: =>
    layerProse = @options.layer
    layerProse = 'page, modal or popup' if layerProse == 'auto'
    up.fail("Could not find #{@options.humanized} in current #{layerProse} (tried %o)", @candidates)

