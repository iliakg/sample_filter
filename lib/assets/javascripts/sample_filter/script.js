$(document).ready(function() {
  if(jQuery().datepicker) {
    $('.datepicker_input').datepicker({
      timepicker: true,
      onShow(dp, animationCompleted){
        if (!animationCompleted) {
          $('.datepicker_input').removeClass('active');
          $(dp.el).addClass('active');;
        }
      }
    });

    $('.datepicker_input').each(function(i, el){
      $(el).data('datepicker').selectDate(parseFilterDate($(el).val()));
    });

    function parseFilterDate(date_string) {
      var dateTimeReg = /(\d{2}).(\d{2}).(\d{4}) (\d{2}):(\d{2})/;
      var dateReg = /(\d{2}).(\d{2}).(\d{4})/;
      var dateTimeArray = dateTimeReg.exec(date_string);
      var dateArray = dateReg.exec(date_string);

      if(dateTimeArray){
        return new Date(dateTimeArray[3],dateTimeArray[2]-1,dateTimeArray[1],dateTimeArray[4],dateTimeArray[5]);
      } else if(dateArray){
        return new Date(dateArray[3],dateArray[2]-1,dateArray[1]);
      }
    }
  }

  $('.sample-filter__clear-form').on('click', function(e) {
    e.preventDefault();
    document.location.href = $(this).parents('form').attr('action');
  });
});
