Config = {
    commands = {
        keys = {
            command = 'lockunlock',
            input = 'u',
            command2 = 'lockunlock child',
            input2 = 'i',
        },
        givekeys = {
            command = 'CR_VehicleLocksGiveKeys',
        },
    },
    use_interact_sound = true,
    notify = {
        title = 'Keys',
        no_vehicle = 'There\'s no nearby vehicles',
        no_keys = 'There\'s no keys in this vehicle',
        vehicle_unlocked = 'Vehicle has been unlocked',
        vehicle_locked = 'Vehicle has been locked',
        error = 'Error',
        argument_1 = 'First argument should be player ID',
        enter_vehicle = 'Enter the vehicle',
        this_vehicle_is_not_your = 'This vehicle is not your',
        success = 'Success',
        keys_gived_to = 'You\'ve gived keys to ',
        lock_unlock = 'Locking/Unlocking vehicle',
    },
}
Config.Job1     = 'police'
Config.Job1Cars = { 
   'MVFEvoke',
   'MarkedXr6Turbo',
   'MarkedHilux',
   '2015polstang',
   'MarkedRaptor',
   'MarkedTerritory',
   'MarkedVFSS',
   'police351',
   'policeVF',
   'vkbt1',
   'policebt1',
   'upolice351',
   'upoliceVF',
   'UMarkedVFSS',
   'UnmarkedTerritory',
   'polmav',
   'polbf400',
   'esprinter',
   'aw139'
}
Config.Job2     = 'ambulance'
Config.Job2Cars = { 
   'esprinter',
   'aw139',
   'tahoe'
}