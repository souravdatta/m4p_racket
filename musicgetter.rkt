#lang typed/racket

(require typed/net/url)
(require (except-in typed/racket/gui build-path))
(require/typed "musicdata.rkt"
               [music-data (-> (List (Listof String)
                                     (Listof String)
                                     (Listof String)))])
(require "musicdownload.rkt")


(: play-file (-> Path Void))
(define (play-file path)
  (system (let ((os-type (system-type 'os)))
            (cond
              ((eq? os-type 'macosx) (format "open ~a" (path->string path)))
              ((eq? os-type 'windows) (format "explorer ~a" (path->string path)))
              (else (path->string path)))))
  (void))

(: download-directory (-> Path))
(define (download-directory)
  (build-path (find-system-path 'home-dir)
              "music4programming_rkt"))

(: build-home-path (-> String Path))
(define (build-home-path title)
  (build-path (download-directory)
              (string-append
               (string-replace (string-replace title " " "_")
                               ":"
                               "_")
               ".mp3")))

(: get-musics (-> Void))
(define (get-musics)
  (let* ([mdata (music-data)]
         [current-selection 0]
         [frame (new frame%
                     [label "Music4Programming"]
                     [height 480]
                     [width 740])]
         [hbox (new horizontal-pane%
                    [parent frame])]
         [vbox (new vertical-pane%
                    [parent hbox])]
         [duration-label (new text-field%
                              [parent vbox]
                              [label "Duration: "]
                              [enabled false])]
         [msgs (new text-field%
                    [parent vbox]
                    [label "Messages"])]
         [button (new button%
                      [parent vbox]
                      [label "Download"]
                      [callback (lambda ([b : (Instance Button%)]
                                         [e : (Instance Control-Event%)])
                                  (let ((file-path (build-home-path (list-ref (first mdata)
                                                                             current-selection))))
                                    (send msgs set-value (format "~a" (path->string file-path)))
                                    (download-music (string->url (list-ref (second mdata)
                                                                           current-selection))
                                                    file-path)
                                    (send msgs set-value (format "~a" (path->string file-path)))
                                    (message-box "Downloaded" (format "~a" (path->string file-path)))
                                    (play-file file-path)))])]
         [list-box (new list-box%
                        [label ""]
                        [parent hbox]
                        [selection current-selection]
                        [choices (first mdata)]
                        [min-width 400]
                        [callback (lambda ([l : (Instance List-Box%)]
                                           [e : (Instance Control-Event%)])
                                    (when (equal? (send e get-event-type)
                                                  'list-box)
                                      (let ([selection : (U Exact-Nonnegative-Integer False)
                                                       (send l get-selection)])
                                        (when selection
                                          (set! current-selection selection)
                                          (send duration-label set-value (list-ref (third mdata)
                                                                                   current-selection))))))])])
    (let ([download-dir (download-directory)])
      (when (not (directory-exists? download-dir))
        (make-directory download-dir))
      (send frame show true)
      (void))))


(provide get-musics)
