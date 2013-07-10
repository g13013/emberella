Emberella.forEachAsync = (context, objects, eachFn, completeFn, runTime = 200, wait = 200) ->
  if (!(Ember.Enumerable.detect(objects) || Ember.isArray(objects)))
    throw new TypeError("Must pass Ember.Enumerable to Emberella.forEachAsync");

  processItems = (items, process, callback) ->
    itemsToProcess = Array.prototype.slice.call(items)
    i = null
    Ember.run(context, ->
      start = +Date.now()
      process.call(context, itemsToProcess.shift(), (if i? then ++i else 0))
      while itemsToProcess.length > 0 and +Date.now() - start < runTime
        process.call(context, itemsToProcess.shift(), ++i)

      if itemsToProcess.length > 0
        Ember.run.later(context, arguments.callee, wait)

      else
        callback.call(context) if callback? and callback.call?
    )

  processItems objects, eachFn, completeFn
