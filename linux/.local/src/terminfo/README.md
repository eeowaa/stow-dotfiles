# Customizing the `linux` terminfo entry

## Background

By default, the Linux terminal uses the hardware cursor, which appears as a
blinking underline. I prefer to see a solid block.

One way to customize the cursor appearance is by setting the `vt.cur_default`
kernel parameter, but there may be some cases where configuring the bootloader
is not feasible. An alternate approach is to redefine the `cnorm` capability in
the `linux` terminfo entry, which is what I've done here.

## Process

1. Disassemble the system terminfo entry for `linux` and store in
   [`system-linux.ti`](system-linux.ti):

   ```sh
   infocmp -A /usr/share/terminfo linux >system-linux.ti
   ```

2. Copy the file to [`custom-linux.ti`](custom-linux.ti) for manual
   customization (i.e. to redefine `cnorm`):

   ```sh
   cp system-linux.ti custom-linux.ti
   vim custom-linux.ti
   ```

3. Compile the customized terminfo entry and install to
   [`$TERMINFO/l/linux`](../../../.config/terminfo/l/linux):

   ```sh
   tic custom-linux.ti
   ```

## References

- Web links
  - [How to change cursor shape, color, and blinkrate of Linux Console? - Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/55423/158305#158305)
  - [The kernel's command-line parameters — The Linux Kernel documentation](https://www.kernel.org/doc/html/v4.10/admin-guide/kernel-parameters.html)
  - [Documentation/VGA-softcursor.txt - kernel/common - Git at Google](https://android.googlesource.com/kernel/common/+/android-3.18/Documentation/VGA-softcursor.txt)
  - [Cursor Appearance in the Linux Console LG #137](https://linuxgazette.net/137/anonymous.html)
- Man pages
  - **terminfo(5)**
  - **term(5)**
  - **infocmp(1M)**
  - **tic(1M)**
