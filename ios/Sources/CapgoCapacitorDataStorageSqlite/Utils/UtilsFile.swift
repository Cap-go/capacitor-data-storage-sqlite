//
//  UtilsFile.swift
//  Plugin
//
//  Created by  Quéau Jean Pierre on 12/04/2021.
//  Copyright © 2021 Max Lynch. All rights reserved.
//

import Foundation
enum UtilsFileError: Error {
    case getFilePathFailed
    case copyFileFailed
    case renameFileFailed
    case deleteFileFailed
    case getAssetsDatabasesPathFailed
    case getDatabasesPathFailed
    case getDatabasesURLFailed
    case getApplicationPathFailed
    case getApplicationURLFailed
    case getLibraryPathFailed
    case getLibraryURLFailed
    case getFileListFailed
    case copyFromAssetToDatabaseFailed
    case copyFromNamesFailed
}

class UtilsFile {

    // MARK: - IsFileExist

    class func isDirExist(dirPath: String) -> Bool {
        var isDir: ObjCBool = true
        let fileManager = FileManager.default
        let exists = fileManager.fileExists(atPath: dirPath, isDirectory: &isDir)
        return exists && isDir.boolValue
    }

    // MARK: - IsFileExist

    class func isFileExist(filePath: String) -> Bool {
        var ret: Bool = false
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            ret = true
        }
        return ret
    }
    class func isFileExist(fileName: String) -> Bool {
        var ret: Bool = false
        do {
            let filePath: String =
                try UtilsFile.getFilePath(
                    fileName: fileName)
            ret = UtilsFile.isFileExist(filePath: filePath)
            return ret
        } catch UtilsFileError.getFilePathFailed {
            return false
        } catch _ {
            return false
        }
    }

    // MARK: - GetFilePath

    class func getFilePath(fileName: String) throws -> String {
        do {
            let url = try getDatabasesUrl()
            return url.appendingPathComponent("\(fileName)").path
        } catch UtilsFileError.getDatabasesURLFailed {
            print("Error: getDatabasesUrl Failed")
            throw UtilsFileError.getFilePathFailed
        }
    }

    // MARK: - getDatabasesUrl

    class func getDatabasesUrl() throws -> URL {
        if let path: String = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first {
            return NSURL(fileURLWithPath: path) as URL
        } else {
            print("Error: getDatabasesURL did not find the document folder")
            throw UtilsFileError.getDatabasesURLFailed
        }
    }

    // MARK: - getDatabasesPath
    class func getDatabasesPath() throws -> String {
        if let path: String = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first {
            return path
        } else {
            print("Error: getDatabasesPath did not find the document folder")
            throw UtilsFileError.getDatabasesPathFailed
        }
    }

    // MARK: - GetFileList

    class func getFileList(path: String) throws -> [String] {
        do {
            var dbs: [String] = []
            let filenames = try FileManager.default
                .contentsOfDirectory(atPath: path)
            let ext: String = ".db"
            for file in filenames {
                if file.hasSuffix(ext) {
                    dbs.append(file)
                }
            }
            return dbs
        } catch let error {
            print("Error: \(error)")
            throw UtilsFileError.getFileListFailed
        }
    }

    // MARK: - CopyFromNames

    class func copyFromNames(dbPathURL: URL, fromFile: String, databaseURL: URL,
                             toFile: String) throws {
        do {
            let uFrom: URL = dbPathURL.appendingPathComponent(fromFile)
            let uTo: URL = databaseURL.appendingPathComponent(toFile)
            let pFrom: String = uFrom.path
            let pTo: String = uTo.path
            let bRet: Bool = try copyFile(pathName: pFrom, toPathName: pTo)
            if bRet {
                return
            } else {
                print("Error: FromNames return false")
                throw UtilsFileError.copyFromNamesFailed
            }
        } catch UtilsFileError.copyFileFailed {
            print("Error: copyFile Failed")
            throw UtilsFileError.copyFromNamesFailed
        }

    }

    // MARK: - CopyFile

    class func copyFile(pathName: String, toPathName: String) throws -> Bool {
        if pathName.count > 0 && toPathName.count > 0 {
            let isPath = isFileExist(filePath: pathName)
            if isPath {
                do {
                    if isFileExist(filePath: toPathName) {
                        _ = try deleteFile(filePath: toPathName)
                    }
                    let fileManager = FileManager.default
                    try fileManager.copyItem(atPath: pathName,
                                             toPath: toPathName)
                    return true
                } catch let error {
                    print("Error: \(error)")
                    throw UtilsFileError.copyFileFailed
                }
            } else {
                print("Error: CopyFilePath Failed pathName does not exist")
                throw UtilsFileError.copyFileFailed
            }
        } else {
            print("Error: CopyFilePath Failed paths count = 0")
            throw UtilsFileError.copyFileFailed
        }
    }

    // MARK: - CopyFile

    class func copyFile(fileName: String, toFileName: String)
    throws -> Bool {
        var ret: Bool = false
        do {
            let fromPath: String = try getFilePath(fileName: fileName)
            let toPath: String = try getFilePath(fileName: toFileName)
            ret = try copyFile(pathName: fromPath, toPathName: toPath)
            return ret
        } catch UtilsFileError.getFilePathFailed {
            print("Error: getFilePath Failed")
            throw UtilsFileError.copyFileFailed
        } catch let error {
            print("Error: \(error)")
            throw UtilsFileError.copyFileFailed
        }
    }

    // MARK: - DeleteFile

    class func deleteFile(filePath: String) throws {
        do {
            if isFileExist(filePath: filePath) {
                let fileManager = FileManager.default
                do {
                    try fileManager.removeItem(atPath: filePath)
                } catch let error {
                    print("Error: \(error)")
                    throw UtilsFileError.deleteFileFailed
                }
            }
            return
        } catch let error {
            print("Error: \(error)")
            throw UtilsFileError.deleteFileFailed
        }
    }

    // MARK: - DeleteFile

    class func deleteFile(fileName: String) throws {
        do {
            let filePath: String = try getFilePath(fileName: fileName)
            try deleteFile(filePath: filePath)
            return
        } catch let error {
            print("Error: \(error)")
            throw UtilsFileError.deleteFileFailed
        }
    }

    // MARK: - RenameFile

    class func renameFile (filePath: String, toFilePath: String)
    throws {
        let fileManager = FileManager.default
        do {
            if isFileExist(filePath: toFilePath) {
                let fileName = URL(
                    fileURLWithPath: toFilePath).lastPathComponent
                try deleteFile(fileName: fileName)
            }
            try fileManager.moveItem(atPath: filePath,
                                     toPath: toFilePath)
        } catch UtilsFileError.deleteFileFailed {
            print("Error: Failed in delete file")
            throw UtilsFileError.renameFileFailed
        } catch let error {
            print("Error: \(error)")
            throw UtilsFileError.renameFileFailed
        }
    }
}
