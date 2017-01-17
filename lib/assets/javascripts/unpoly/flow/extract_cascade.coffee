u = up.util

class up.flow.ExtractCascade

  constructor: (candidates, options) ->
    @options = u.options(options, humanized: 'selector', layer: 'auto')
    @candidates = u.simplifyArray(candidates)
    @plans = u.map candidates, (candidate, i) ->
      planOptions = u.copy(@options)
      if i > 0
        planOptions.transition = up.flow.config.fallbackTransition
      new up.flow.ExtractPlan(candidate, planOptions)

  bestOldSelector: =>
    for plan in @plans
      if plan.oldExists()
        return plan.selector
    @oldPlanNotFound()

  oldPlanNotFound: ->
    layerProse = @options.layer
    layerProse = 'page, modal or popup' if layerProse == 'auto'
    up.fail("Could not find #{@options.humanized} in the current #{layerProse} (tried %o)", @candidates)

  bestMatchingSteps: ->
    if plan = u.detect @plans, (plan) -> plan.matchExists()
      return plan.steps
    @matchingPlanNotFound()

  matchingPlanNotFound: =>
    message = "Could not match targets in current page and response"
    if options.inspectResponse
      inspectAction = { label: 'Open response', callback: options.inspectResponse }
    up.fail(["#{message} (tried %o)", selectorCandidates], action: inspectAction)
