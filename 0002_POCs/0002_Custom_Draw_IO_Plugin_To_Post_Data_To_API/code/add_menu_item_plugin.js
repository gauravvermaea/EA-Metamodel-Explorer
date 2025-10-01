Draw.loadPlugin(function(ui) {

    alert('Plugin Loading');
    // Define an action
    ui.actions.addAction('showAlert', function() {
        alert('Hello from My Plugin!');
    });

    // Create a new top-level menu
    ui.menubar.addMenu('My Plugin', function(menu, parent) {
        ui.menubar.addMenuItem(menu, 'showAlert');
    });
    
    alert('Plugin Loaded');
    
}
);
