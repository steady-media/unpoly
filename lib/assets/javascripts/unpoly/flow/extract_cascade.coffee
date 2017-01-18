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

  bestOldSelector: =>
    for plan in @plans
      if plan.oldExists()
        return plan.selector
    @oldPlanNotFound()

  oldPlanNotFound: =>
    layerProse = @options.layer
    layerProse = 'page, modal or popup' if layerProse == 'auto'
    up.fail("Could not find #{@options.humanized} in the current #{layerProse} (tried %o)", @candidates)

  bestMatchingSteps: =>
    matchingPlan = u.detect @plans, (plan) -> plan.matchExists()
    if matchingPlan
      return matchingPlan.steps
    @matchingPlanNotFound()

  matchingPlanNotFound: =>
    message = "Could not match targets in current page and response"
    if @options.inspectResponse
      inspectAction = { label: 'Open response', callback: @options.inspectResponse }
    up.fail(["#{message} (tried %o)", @candidates], action: inspectAction)
