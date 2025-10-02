Draw.loadPlugin(function(ui) {
    // 1. Register a new action
    ui.actions.addAction('showAlert', function() {
        alert('Hello from my custom plugin!');
    });



const apiUrl = 'https://api.restful-api.dev/objects'; // Replace with your actual API endpoint

// Make a GET request


     ui.actions.addAction('call_get', function() {
         fetch(apiUrl)
        .then((response) => response.json())
        .then((json) => console.log(json));
    });

    // 2. Add it into an existing menu ("extras" works well)
    ui.menus.get('extras').funct = (function(oldFunct){
        return function(menu, parent) {
            // Call the original menu builder
            oldFunct.apply(this, arguments);
            // Add our custom menu item at the end
            ui.menus.addMenuItem(menu, 'showAlert', parent);
            ui.menus.addMenuItem(menu, 'call_get', parent);
        };
    })(ui.menus.get('extras').funct);
});
