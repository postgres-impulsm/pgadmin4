define([
            'jquery',
            'underscore',
            'underscore.string'
        ],
function($, _) {
    'use strict'
    
    var module = {
        getColouredAciTreeLabel: function(data) {
            var colour = null
            
            if (data.colour) {
                colour = data.colour
            } else if (data._colour) {
                colour = data._colour
            }
            
            if (!colour) {
                return _.escape(data._label) + (
                    data.collection_count ?
                            ' <span>(' + data.collection_count + ')</span>' :
                            ''
                )
            }
            
            return '<span ' +
                    'style="background-color: ' + _.escape(colour) + '; border-radius: 2px; padding: 1px">' +
                    _.escape(data._label) + (
                        data.collection_count ?
                                ' <span>(' + data.collection_count + ')</span>' :
                                ''
                    ) +
                    '</span>'
        },
        getColourFromItem: function(api, item) {
            var data = api.itemData($(item))
            
            if (!data) {
                return null
            }
            
            var colour = data.colour
            
            if (!colour) {
                return null
            }
            
            return colour
        },
        colourItem: function(api, item, colour) {
            var data = api.itemData($(item))
            
            if (!data || data._colour === colour) {
                return
            }
            
            if (colour) {
                data._colour = colour
            } else {
                delete data._colour
            }
            
            api.setLabel($(item), {
                label: module.getColouredAciTreeLabel(data)
            })
        },
        aciTreeEventHandler: function(obj, event, api, item, eventName, options) {
            if ([
                        'appended',
                        'opened',
                        'moved',
                        'labelset',
                    ].indexOf(eventName) === -1) {
                return
            }
            
            var parentColour = null
            var parentItem = item
            
            for (;;) {
                if (parentItem === null) {
                    break
                }
                
                parentColour = module.getColourFromItem(api, parentItem)
                
                if (!api.hasParent($(parentItem))) {
                    break
                }
                
                parentItem = api.parent($(parentItem))
            }
            
            var doneList = []
            
            function recursive(item, colour) {
                doneList.push(item)
                
                if (item) {
                    var itemColour = module.getColourFromItem(api, item)
                    
                    if (itemColour) {
                        colour = itemColour
                    }
                    
                    module.colourItem(api, item, colour)
                }
                
                var children
                
                if (item) {
                    children = api.children($(item), false, false)
                } else {
                    children = api.children(null, false, false)
                }
                
                for (var i = 0; i < children.length; ++i) {
                    var child = children[i]
                    
                    if (doneList.indexOf(child) !== -1) {
                        continue
                    }
                    
                    recursive(child, colour)
                }
            }
            
            recursive(item, parentColour)
        },
    }
    
    return module
})
