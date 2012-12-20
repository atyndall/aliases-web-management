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
        n.clone().removeAttr('id').addClass('unsaved').insertAfter(n)


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
        if window.confirm('Are you sure you want to delete "' + dest + '" from "' + alias + '"?')
          if /^[a-zA-Z0-9]+$/.test(dest)
            $(this).parent().siblings('li.new').children('select').append($('<option value="' + dest + '">' + dest + ' ' + window.domain + '</option>'))
          $(this).parent().remove()
      when 'alias'
        if window.confirm('Are you sure you want to delete the "' + alias + '" alias? This will also delete any references to this list as a destination.')
          delete window.aliases[alias]
          for k, v of window.aliases
            v.remove(alias)

          $(this).closest('tr').remove()
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
          li.after(newe)
          li.remove()
          window.aliases[alias].push newv


  $('#management').on 'input', '.unsaved input', ->
    $(this).siblings('select').val('Internal Email')

  $('#management').on 'change', '.unsaved select', ->
    $(this).siblings('input').val('')


  $('#saveall button').click ->
    window.alert('unimplemented')


  $.ajax
    type: 'GET'
    url: '/aliases.json'
    dataType: 'json'

    success: (data) ->
      window.aliases = data
      $('#saveall button').removeAttr('disabled')
      $('.add, .remove, .save').removeAttr('style')

    error: (xhr, ajaxOptions, thrownError) ->
      window.alert('Something went wrong when retrieving more alias information. Error: ' + thrownError);
