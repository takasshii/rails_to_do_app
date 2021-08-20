document.addEventListener('DOMContentLoaded', function() {

  flatpickr.l10ns.ja.firstDayOfWeek = 0;  
  flatpickr('#datetimepicker1', {
     wrap : true,
     dateFormat : 'Y/m/d',
     locale : 'ja',
     clickOpens : false,
     allowInput : true,
     monthSelectorType : 'static'
   });
   
   let now = new Date();
   flatpickr('#datetimepicker2', {
     wrap : true,
     enableTime : true,
     noCalendar : true,
     defaultHour : now.getHours(),
     defaultMinute : now.getMinutes(),
     dateFormat : 'H:i',
     minuteIncrement : 1,
     locale : 'ja',
     clickOpens : false,
     allowInput : true,
   });
   
   flatpickr('#datetimepicker3', {
     wrap : true,
     enableTime : true,
     dateFormat : 'Y/m/d H:i',
     defaultHour : now.getHours(),
     defaultMinute : now.getMinutes(),
     minuteIncrement : 1,
     locale : 'ja',
     clickOpens : false,
     allowInput : true,
     monthSelectorType : 'static'
   });
 });
 