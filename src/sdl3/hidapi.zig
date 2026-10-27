//! HIDAPI (SDL_hidapi.h)

const std = @import("std");
const builtin = @import("builtin");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// SDL's HIDAPI functions, in a namespace since their C names are prefixed
/// with `SDL_hid_`.
pub const hid = struct {
    /// The `wchar_t` type, used for HID strings.
    pub const wchar_t = if (builtin.os.tag == .windows) u16 else u32;

    /// An opaque handle representing an open HID device.
    pub const Device = opaque {};

    /// HID underlying bus types.
    pub const BusType = enum(c_int) {
        /// Unknown bus type
        unknown = 0x00,
        /// USB bus Specifications: https://usb.org/hid
        usb = 0x01,
        /// Bluetooth or Bluetooth LE bus Specifications: https://www.bluetooth.com/specifications/specs/human-interface-device-profile-1-1-1/ https://www.bluetooth.com/specifications/specs/hid-service-1-0/ https://www.bluetooth.com/specifications/specs/hid-over-gatt-profile-1-0/
        bluetooth = 0x02,
        /// I2C bus Specifications: https://docs.microsoft.com/previous-versions/windows/hardware/design/dn642101(v=vs.85)
        i2c = 0x03,
        /// SPI bus Specifications: https://www.microsoft.com/download/details.aspx?id=103325
        spi = 0x04,
    };

    /// Information about a connected HID device
    pub const DeviceInfo = extern struct {
        /// Platform-specific device path
        path: ?[*:0]u8,
        /// Device Vendor ID
        vendor_id: c_ushort,
        /// Device Product ID
        product_id: c_ushort,
        /// Serial Number
        serial_number: ?[*:0]wchar_t,
        /// Device Release Number in binary-coded decimal, also known as Device
        /// Version Number
        release_number: c_ushort,
        /// Manufacturer String
        manufacturer_string: ?[*:0]wchar_t,
        /// Product string
        product_string: ?[*:0]wchar_t,
        /// Usage Page for this Device/Interface (Windows/Mac/hidraw only)
        usage_page: c_ushort,
        /// Usage for this Device/Interface (Windows/Mac/hidraw only)
        usage: c_ushort,
        /// The USB interface which this logical device represents.
        ///
        /// Valid only if the device is a USB HID device. Set to -1 in all other
        /// cases.
        interface_number: c_int,
        /// Additional information about the USB interface. Valid on libusb and
        /// Android implementations.
        interface_class: c_int,
        interface_subclass: c_int,
        interface_protocol: c_int,
        /// Underlying bus type
        bus_type: BusType,
        /// Pointer to the next device
        next: ?*DeviceInfo,
    };

    /// Initialize the HIDAPI library.
    ///
    /// This function initializes the HIDAPI library. Calling it is not strictly
    /// necessary, as it will be called automatically by `hid.enumerate` and
    /// any of the SDL_hid_open_*() functions if it is needed. This function should
    /// be called at the beginning of execution however, if there is a chance of
    /// HIDAPI handles being opened by different threads simultaneously.
    ///
    /// Each call to this function should have a matching call to `hid.exit`
    pub fn init() Error!void {
        if (SDL_hid_init() < 0) return makeError();
    }
    extern fn SDL_hid_init() c_int;

    /// Finalize the HIDAPI library.
    ///
    /// This function frees all of the static data associated with HIDAPI. It
    /// should be called at the end of execution to avoid memory leaks.
    pub fn exit() Error!void {
        if (SDL_hid_exit() < 0) return makeError();
    }
    extern fn SDL_hid_exit() c_int;

    /// Check to see if devices may have been added or removed.
    ///
    /// Enumerating the HID devices is an expensive operation, so you can call this
    /// to see if there have been any system device changes since the last call to
    /// this function. A change in the counter returned doesn't necessarily mean
    /// that anything has changed, but you can call `hid.enumerate` to get an
    /// updated device list.
    ///
    /// Calling this function for the first time may cause a thread or other system
    /// resource to be allocated to track device change notifications.
    pub const deviceChangeCount = SDL_hid_device_change_count;
    extern fn SDL_hid_device_change_count() u32;

    /// Enumerate the HID Devices.
    ///
    /// This function returns a linked list of all the HID devices attached to the
    /// system which match vendor_id and product_id. If `vendor_id` is set to 0
    /// then any vendor matches. If `product_id` is set to 0 then any product
    /// matches. If `vendor_id` and `product_id` are both set to 0, then all HID
    /// devices will be returned.
    ///
    /// By default SDL will only enumerate controllers, to reduce risk of hanging
    /// or crashing on bad drivers, but `hint_hidapi_enumerate_only_controllers`
    /// can be set to "0" to enumerate all HID devices.
    ///
    /// Returns null in the case of failure or if no HID devices are present on
    /// the system.
    pub fn enumerate(vendor_id: c_ushort, product_id: c_ushort) ?*DeviceInfo {
        return SDL_hid_enumerate(vendor_id, product_id);
    }
    extern fn SDL_hid_enumerate(vendor_id: c_ushort, product_id: c_ushort) ?*DeviceInfo;

    /// Free an enumeration linked list.
    ///
    /// This function frees a linked list created by `hid.enumerate`.
    pub const freeEnumeration = SDL_hid_free_enumeration;
    extern fn SDL_hid_free_enumeration(devs: ?*DeviceInfo) void;

    /// Open a HID device using a Vendor ID (VID), Product ID (PID) and optionally
    /// a serial number.
    ///
    /// If `serial_number` is null, the first device with the specified VID and PID
    /// is opened.
    pub fn open(vendor_id: c_ushort, product_id: c_ushort, serial_number: ?[*:0]const wchar_t) Error!*Device {
        return SDL_hid_open(vendor_id, product_id, serial_number) orelse makeError();
    }
    extern fn SDL_hid_open(vendor_id: c_ushort, product_id: c_ushort, serial_number: ?[*:0]const wchar_t) ?*Device;

    /// Open a HID device by its path name.
    ///
    /// The path name be determined by calling `hid.enumerate`, or a
    /// platform-specific path name can be used (eg: /dev/hidraw0 on Linux).
    pub fn openPath(path: [:0]const u8) Error!*Device {
        return SDL_hid_open_path(path.ptr) orelse makeError();
    }
    extern fn SDL_hid_open_path(path: [*:0]const u8) ?*Device;

    /// Get the properties associated with a `hid.Device`.
    ///
    /// The following read-only properties are provided by SDL:
    ///
    /// - `hid.prop_libusb_device_handle_pointer`: the libusb_device_handle
    ///   associated with the device, if it was opened using libusb.
    pub fn getProperties(dev: *Device) Error!sdl.PropertiesId {
        const result = SDL_hid_get_properties(dev);
        if (result == .invalid) return makeError();
        return result;
    }
    extern fn SDL_hid_get_properties(dev: *Device) sdl.PropertiesId;

    pub const prop_libusb_device_handle_pointer = "SDL.hidapi.libusb.device.handle";

    /// Write an Output report to a HID device.
    ///
    /// The first byte of `data` must contain the Report ID. For devices which only
    /// support a single report, this must be set to 0x0. The remaining bytes
    /// contain the report data. Since the Report ID is mandatory, calls to
    /// `hid.write` will always contain one more byte than the report contains.
    /// For example, if a hid report is 16 bytes long, 17 bytes must be passed to
    /// `hid.write`, the Report ID (or 0x0, for devices with a single report),
    /// followed by the report data (16 bytes). In this example, the length passed
    /// in would be 17.
    ///
    /// `hid.write` will send the data on the first OUT endpoint, if one
    /// exists. If it does not, it will send the data through the Control Endpoint
    /// (Endpoint 0).
    pub fn write(dev: *Device, data: []const u8) Error!usize {
        const result = SDL_hid_write(dev, data.ptr, @intCast(data.len));
        if (result < 0) return makeError();
        return @intCast(result);
    }
    extern fn SDL_hid_write(dev: *Device, data: [*]const u8, length: usize) c_int;

    /// Read an Input report from a HID device with timeout.
    ///
    /// Input reports are returned to the host through the INTERRUPT IN endpoint.
    /// The first byte will contain the Report number if the device uses numbered
    /// reports.
    pub fn readTimeout(dev: *Device, data: []u8, milliseconds: c_int) Error!usize {
        const result = SDL_hid_read_timeout(dev, data.ptr, @intCast(data.len), milliseconds);
        if (result < 0) return makeError();
        return @intCast(result);
    }
    extern fn SDL_hid_read_timeout(dev: *Device, data: [*]u8, length: usize, milliseconds: c_int) c_int;

    /// Read an Input report from a HID device.
    ///
    /// Input reports are returned to the host through the INTERRUPT IN endpoint.
    /// The first byte will contain the Report number if the device uses numbered
    /// reports.
    pub fn read(dev: *Device, data: []u8) Error!usize {
        const result = SDL_hid_read(dev, data.ptr, @intCast(data.len));
        if (result < 0) return makeError();
        return @intCast(result);
    }
    extern fn SDL_hid_read(dev: *Device, data: [*]u8, length: usize) c_int;

    /// Set the device handle to be non-blocking.
    ///
    /// In non-blocking mode calls to `hid.read` will return immediately with a
    /// value of 0 if there is no data to be read. In blocking mode, `hid.read`
    /// will wait (block) until there is data to read before returning.
    ///
    /// Nonblocking can be turned on and off at any time.
    pub fn setNonblocking(dev: *Device, nonblock: bool) Error!void {
        if (SDL_hid_set_nonblocking(dev, @intFromBool(nonblock)) < 0) return makeError();
    }
    extern fn SDL_hid_set_nonblocking(dev: *Device, nonblock: c_int) c_int;

    /// Send a Feature report to the device.
    ///
    /// Feature reports are sent over the Control endpoint as a Set_Report
    /// transfer. The first byte of `data` must contain the Report ID. For devices
    /// which only support a single report, this must be set to 0x0. The remaining
    /// bytes contain the report data. Since the Report ID is mandatory, calls to
    /// `hid.sendFeatureReport` will always contain one more byte than the
    /// report contains. For example, if a hid report is 16 bytes long, 17 bytes
    /// must be passed to `hid.sendFeatureReport`: the Report ID (or 0x0, for
    /// devices which do not use numbered reports), followed by the report data (16
    /// bytes). In this example, the length passed in would be 17.
    pub fn sendFeatureReport(dev: *Device, data: []const u8) Error!usize {
        const result = SDL_hid_send_feature_report(dev, data.ptr, @intCast(data.len));
        if (result < 0) return makeError();
        return @intCast(result);
    }
    extern fn SDL_hid_send_feature_report(dev: *Device, data: [*]const u8, length: usize) c_int;

    /// Get a feature report from a HID device.
    ///
    /// Set the first byte of `data` to the Report ID of the report to be read.
    /// Make sure to allow space for this extra byte in `data`. Upon return, the
    /// first byte will still contain the Report ID, and the report data will start
    /// in data[1].
    pub fn getFeatureReport(dev: *Device, data: []u8) Error!usize {
        const result = SDL_hid_get_feature_report(dev, data.ptr, @intCast(data.len));
        if (result < 0) return makeError();
        return @intCast(result);
    }
    extern fn SDL_hid_get_feature_report(dev: *Device, data: [*]u8, length: usize) c_int;

    /// Get an input report from a HID device.
    ///
    /// Set the first byte of `data` to the Report ID of the report to be read.
    /// Make sure to allow space for this extra byte in `data`. Upon return, the
    /// first byte will still contain the Report ID, and the report data will start
    /// in data[1].
    pub fn getInputReport(dev: *Device, data: []u8) Error!usize {
        const result = SDL_hid_get_input_report(dev, data.ptr, @intCast(data.len));
        if (result < 0) return makeError();
        return @intCast(result);
    }
    extern fn SDL_hid_get_input_report(dev: *Device, data: [*]u8, length: usize) c_int;

    /// Close a HID device.
    pub fn close(dev: *Device) Error!void {
        if (SDL_hid_close(dev) < 0) return makeError();
    }
    extern fn SDL_hid_close(dev: *Device) c_int;

    /// Get The Manufacturer String from a HID device.
    pub fn getManufacturerString(dev: *Device, string: []wchar_t) Error!void {
        if (SDL_hid_get_manufacturer_string(dev, string.ptr, string.len) < 0) return makeError();
    }
    extern fn SDL_hid_get_manufacturer_string(dev: *Device, string: [*]wchar_t, maxlen: usize) c_int;

    /// Get The Product String from a HID device.
    pub fn getProductString(dev: *Device, string: []wchar_t) Error!void {
        if (SDL_hid_get_product_string(dev, string.ptr, string.len) < 0) return makeError();
    }
    extern fn SDL_hid_get_product_string(dev: *Device, string: [*]wchar_t, maxlen: usize) c_int;

    /// Get The Serial Number String from a HID device.
    pub fn getSerialNumberString(dev: *Device, string: []wchar_t) Error!void {
        if (SDL_hid_get_serial_number_string(dev, string.ptr, string.len) < 0) return makeError();
    }
    extern fn SDL_hid_get_serial_number_string(dev: *Device, string: [*]wchar_t, maxlen: usize) c_int;

    /// Get a string from a HID device, based on its string index.
    pub fn getIndexedString(dev: *Device, string_index: c_int, string: []wchar_t) Error!void {
        if (SDL_hid_get_indexed_string(dev, string_index, string.ptr, string.len) < 0) return makeError();
    }
    extern fn SDL_hid_get_indexed_string(dev: *Device, string_index: c_int, string: [*]wchar_t, maxlen: usize) c_int;

    /// Get the device info from a HID device.
    pub fn getDeviceInfo(dev: *Device) Error!*DeviceInfo {
        return SDL_hid_get_device_info(dev) orelse makeError();
    }
    extern fn SDL_hid_get_device_info(dev: *Device) ?*DeviceInfo;

    /// Get a report descriptor from a HID device.
    ///
    /// User has to provide a preallocated buffer where descriptor will be copied
    /// to. The recommended size for a preallocated buffer is 4096 bytes.
    pub fn getReportDescriptor(dev: *Device, buf: []u8) Error!usize {
        const result = SDL_hid_get_report_descriptor(dev, buf.ptr, buf.len);
        if (result < 0) return makeError();
        return @intCast(result);
    }
    extern fn SDL_hid_get_report_descriptor(dev: *Device, buf: [*]u8, buf_size: usize) c_int;

    /// Start or stop a BLE scan on iOS and tvOS to pair Steam Controllers.
    pub const bleScan = SDL_hid_ble_scan;
    extern fn SDL_hid_ble_scan(active: bool) void;
};
