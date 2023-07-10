(function() {
  if (undefined == window['J2C']) {
    window['J2C'] = {}
  }
  // 获取日历列表
  let getCalendarsCallback
  function getCalendars(info, callback) {
    getCalendarsCallback = callback
    let methodName = /function\s*(\w*)/i.exec(arguments.callee.toString())[1]
    console.log('[methodName]' + methodName)
    window.webkit.messageHandlers[methodName].postMessage(info)
  }
  function callback4getCalendars(callbackInfo) {
    getCalendarsCallback(callbackInfo)
  }

  // 获取日历事件列表
  let getCalendarEventCallback
  function getCalendarEvent(info, callback) {
    getCalendarEventCallback = callback
    let methodName = /function\s*(\w*)/i.exec(arguments.callee.toString())[1]
    console.log('[methodName]' + methodName)
    window.webkit.messageHandlers[methodName].postMessage(info)
  }
  function callback4getCalendarEvent(callbackInfo) {
    getCalendarEventCallback(callbackInfo)
  }

  window['J2C']['getCalendars'] = getCalendars
  window['J2C']['callback4getCalendars'] = callback4getCalendars

  window['J2C']['getCalendarEvent'] = getCalendarEvent
  window['J2C']['callback4getCalendarEvent'] = callback4getCalendarEvent


})()
