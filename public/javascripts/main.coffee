window.aliases = null

Array::remove = ->
  what = undefined
  a = arguments
  L = a.length
  ax = undefined
  while L and @length
    what = a[--L]
    @splice ax, 1  while (ax = @indexOf(what)) isnt -1
  this

unless Array::indexOf
  Array::indexOf = (what, i) ->
    i = i or 0
    L = @length
    while i < L
      return i  if this[i] is what
      ++i
    -1

$(document).ready ->
  $('#management').on 'click', 'span.add', ->
    switch $(this).attr('aliases-type')
      when 'destination'
        n = $(this).siblings('ul')
        n.children('.new').clone().removeClass('new').addClass('unsaved').appendTo(n)
      when 'alias'
        n = $('#atemplate')
        n.clone().removeAttr('id').removeClass('template').addClass('unsaved').insertAfter(n)


  $('#management').on 'click', 'span.remove',  ->
    alias = $(this).attr('aliases-alias')
    dest = $(this).attr('aliases-destination')
    type = $(this).attr('aliases-type')

    switch type
      when 'unsaved-dest'
        $(this).parent().remove()
      when 'unsaved-alias'
        $(this).closest('tr').remove()
      when 'destination'
        if confirm('Are you sure you want to delete "' + dest + '" from "' + alias + '"?')
          window.aliases[alias].remove(dest)
          if /^[a-zA-Z0-9]+$/.test(dest)
            $(this).parent().siblings('li.new').children('select').append($('<option value="' + dest + '">' + dest + ' ' + window.domain + '</option>'))
          $(this).parent().remove()
      when 'alias'
        if confirm('Are you sure you want to delete the "' + alias + '" alias? This will also delete any references to this list as a destination.')
          delete window.aliases[alias]
          for k, v of window.aliases
            v.remove(alias)

          $(this).closest('tr').remove()
          $('#management td.to li.new select option[value="' + alias + '"]').remove()
          $('li[aliases-destination="' + alias + '"]').remove()


  $('#management').on 'click', 'span.save', ->
    alias = $(this).attr('aliases-alias')
    dest = $(this).attr('aliases-destination')
    type = $(this).attr('aliases-type')
    li = $(this).closest('li')

    switch type
      when 'destination'
        newe = null
        newv = null
        sval = li.children('select').val()
        emval = li.children('input').val()
        if sval != ''
          newe = $('#dest-alias-template').clone().removeAttr('id').attr('aliases-destination', sval)
          newe.children('.name').text(sval)
          rm = newe.children('.remove')
          rm.attr('aliases-destination', sval)
          rm.attr('aliases-alias', alias)

          li.siblings('li.new').children('select').children('option[value="' + sval + '"]').remove()

          newv = sval
        else if emval != ''
          email = new RegExp('^' + li.children('input').attr('pattern') + '$', 'g')
          domain = new RegExp('.*' + window.domain + '$', 'g')

          if email.test(emval)
            if domain.test(emval)
              alert('Please use the drop down menu instead of manually specifying an alias')
            else if $.inArray(emval, window.aliases[alias]) > -1
              alert('This email address is already a destination for this alias')
            else
              newe = $('#dest-email-template').clone().removeAttr('id').attr('aliases-destination', emval)
              newe.children('.email').text(emval)
              rm = newe.children('.remove')
              rm.attr('aliases-destination', emval)
              rm.attr('aliases-alias', alias)

              newv = emval
          else
            alert('Email address is not correctly formatted')
        else
          alert('You need to enter details!')

        if newe and newv
          window.aliases[alias].push newv
          li.after(newe)
          li.remove()

      when 'alias'
        input = $(this).siblings('p').children('input')
        alias = new RegExp('^' + input.attr('pattern') + '$', 'g')
        if alias.test(input.val())
          if window.aliases[input.val()] == undefined
            window.aliases[input.val()] = []
            $(this).closest('tr').removeClass('newalias')
            $(this).closest('td').children('span.remove').attr('aliases-type', 'alias').attr('aliases-alias', input.val())
            $(this).closest('tr').find('td.to span.save').attr('aliases-alias', input.val())
            $(this).closest('td').children('span.save').remove()
            $('#management td.to li.new select').append($('<option value="' + input.val() + '">' + input.val() + ' ' + window.domain + '</option>'))
            input.replaceWith( $('<span class="name">' + input.val() + '</span>') )
          else
            alert('An alias with that name already exists')
        else
          alert('Alias must be alphanumeric only')


  $('#management').on 'input', '.unsaved input', ->
    $(this).siblings('select').val('Internal Email')

  $('#management').on 'change', '.unsaved select', ->
    $(this).siblings('input').val('')


  $('#saveall button').click ->
    $(this).attr('disabled', 'disabled');
    $(this).text('Saving...')

    $.ajax
      type: 'POST'
      url: '/aliases.json'
      data : JSON.stringify(window.aliases)
      contentType : 'application/json'

      success: (data) ->
        # if data == error
        alert('Data saved')
        window.location.reload(false)

      error: (xhr, ajaxOptions, thrownError) ->
        window.alert('Something went wrong when saving alias information. Error: ' + thrownError);


  $.ajax
    type: 'GET'
    url: '/aliases.json'
    dataType: 'json'

    success: (data) ->
      window.aliases = data
      $('#saveall button').removeAttr('disabled')
      $('.add, .remove, .save').removeAttr('style')

    error: (xhr, ajaxOptions, thrownError) ->
      alert('Something went wrong when retrieving more alias information. Error: ' + thrownError);
