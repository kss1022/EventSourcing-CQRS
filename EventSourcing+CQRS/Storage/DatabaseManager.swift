//
//  DatabaseManager.swift
//  Routine
//  https://github.com/stephencelis/SQLite.swift/blob/master/Documentation/Index.md#sqliteswift-documentation
//
//  https://www.sqlite.org/foreignkeys.html#fk_actions
//  Created by 한현규 on 2023/09/21.
//

import Foundation
import SQLite



class DatabaseManager{
    
    
    // MARK: Private
    private let db : Connection
    
    // MARK: Public
    public static let `default` = try? DatabaseManager()
    
    public let userDao: UserDao
    public let groupDao: GroupDao
    public let groupUserDao: GroupUserDao
    
    
    
    private init() throws {
        guard let directoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else{
            throw DatabaseException.couldNotFindPathToCreateDatabasePath
        }
        
        let path = (directoryPath as NSString).appendingPathComponent("RoutineDB.sqlite3")
        Log.d("RoutineSQLitePath \(path)")
        
        db = try Connection(path)
        db.foreignKeys = true
        
#if DEBUG
        try UserSQLDao.dropTable(db: db)
        try GroupUserSQLDao.dropTable(db: db)
        try GroupSQLDao.dropTable(db: db)
#endif
        userDao = try UserSQLDao(db: db)
        groupDao = try GroupSQLDao(db: db)
        groupUserDao = try GroupUserSQLDao(db: db)
        
        
    }
    
}


