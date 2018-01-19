import Foundation

#if os(macOS)
import COSXFUSE
#elseif os(Linux)
import CLINUXFUSE
#else
fatalError("Unsupported OS")
#endif


let fileContent = "I'm the content of the only file available there\n"


func helloGetAttr(path: UnsafePointer<Int8>!, statInfo: UnsafeMutablePointer<stat>!) -> Int32 {

    memset(statInfo, 0, MemoryLayout<stat>.size)

    if strcmp(path, "/") == 0 {

        statInfo.pointee.st_mode = 493 | S_IFDIR
        statInfo.pointee.st_nlink = 3

    } else if strcmp(path, "/hello.txt") == 0 {

        statInfo.pointee.st_mode = 292 | S_IFREG
        statInfo.pointee.st_nlink = 1
        statInfo.pointee.st_size = off_t(strlen(fileContent))

    } else {
        return -ENOENT
    }

    return 0
}

func helloOpen(path: UnsafePointer<Int8>!, fi: UnsafeMutablePointer<fuse_file_info>!) -> Int32 {

    guard strcmp(path, "/hello.txt") == 0 else {

        return -ENOENT
    }

    guard (fi.pointee.flags & O_ACCMODE) == O_RDONLY else {

        return -EACCES
    }

    return 0
}


func helloReadDir(path: UnsafePointer<Int8>!, buf: UnsafeMutableRawPointer!, filler: fuse_fill_dir_t!, offset: off_t, fi: UnsafeMutablePointer<fuse_file_info>!) -> Int32 {

    guard strcmp(path, "/") == 0 else {

        return -ENOENT
    }

    _ = filler(buf, ".", nil, 0)
    _ = filler(buf, "..", nil, 0)
    _ = filler(buf, "hello.txt", nil, 0)

    return 0
}

func helloRead(path: UnsafePointer<Int8>!, buf: UnsafeMutablePointer<CChar>!, size: size_t, offset: off_t, fi: UnsafeMutablePointer<fuse_file_info>?) -> Int32 {

    guard strcmp(path, "/hello.txt") == 0 else {

        return -ENOENT
    }

    guard var data = fileContent.data(using: .utf8) else {

        return -ENOENT
    }

    let fileLength = Int64(data.count)

    if (offset >= fileLength) {
      return 0
    }

    if (offset.advanced(by: size) > fileLength) {

        let size = fileLength.advanced(by: Int(-offset)) 
        _ = data.withUnsafeBytes { pointer in
            
            memcpy(buf, pointer.advanced(by: Int(offset)), Int(size))
        }
        return Int32(size)
    }

    _ = data.withUnsafeBytes { pointer in

        memcpy(buf, pointer.advanced(by: Int(offset)), size)
    }

    return Int32(size)
}

var fuseOperations = fuse_operations()
fuseOperations.getattr = helloGetAttr
fuseOperations.open = helloOpen
fuseOperations.readdir = helloReadDir
fuseOperations.read = helloRead


fuse_main_real(CommandLine.argc, CommandLine.unsafeArgv, &fuseOperations, MemoryLayout.size(ofValue: fuseOperations), nil)
