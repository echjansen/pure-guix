;; systems/t15.scm — Physical Lenovo ThinkPad T15

(define-module (systems t15)
  #:use-module (gnu)
  #:use-module (gnu system)
  #:use-module (gnu system keyboard)
  #:use-module (gnu system file-systems)
  #:use-module (gnu packages package-management)
  #:use-module (guix channels)
  #:use-module (fleet channels)       ;; imports %fleet-channels — no load, no path tricks
  #:use-module (profiles laptop)
  #:export (%t15-system))

(define %t15-base
  (operating-system
   (host-name "t15")
   (timezone "Australia/Melbourne")
   (locale "en_AU.utf8")
   (keyboard-layout (keyboard-layout "us"))

   ;; UEFI bootloader — correct for all modern ThinkPads
   (bootloader
    (bootloader-configuration
     (bootloader grub-efi-bootloader)
     (targets '("/boot/efi"))))

   (file-systems
    (cons* (file-system
            (device (file-system-label "guix-root"))
            (mount-point "/")
            (type "ext4"))
           (file-system
            (device (file-system-label "guix-efi"))
            (mount-point "/boot/efi")
            (type "vfat"))
           %base-file-systems))

   (users
    (cons (user-account
           (name "echjansen")
           (comment "Ech Jansen")
           (group "users")
           (supplementary-groups '("wheel" "netdev" "audio" "video" "lp")))
          %base-user-accounts))

   ;; Start from %desktop-services — provides GDM, elogind, dbus,
   ;; NetworkManager, and all other desktop plumbing.
   ;; The laptop-profile's desktop-feature adds gnome-desktop-service-type on top.
   ;; sudo for wheel is already the default — no override needed.
   (services
    (modify-services %desktop-services
                     ;; Embed fleet channels: all users' `guix pull` uses pinned revisions
                     (guix-service-type config =>
                                        (guix-configuration
                                         (inherit config)
                                         (channels %fleet-channels)
                                         (guix (guix-for-channels %fleet-channels))))))))

;; Apply the laptop profile, then add the user's authorized SSH key.
;; Authorized keys live here, not in server-feature, because they are
;; user-specific — features must remain user-agnostic.
(define %t15-system
  (let ((profiled (laptop-profile %t15-base)))
    (operating-system
     (inherit profiled)
     (services
      (cons (simple-service 'ssh-authorized-keys
                            openssh-service-type
                            `(("echjansen"
                               ,(plain-file "echjansen.pub"
                                            "ssh-ed25519 AAAAC3... echjansen@t15"))))
            (operating-system-services profiled))))))
