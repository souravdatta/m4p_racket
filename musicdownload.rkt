#lang typed/racket

(require typed/net/url)

(: download-music (-> url
                      Path
                      Void))
(define (download-music resource file)
  (when (not (file-exists? file))
    (let ([outp (open-output-file file
                                  #:mode 'binary)])
      (let-values (([b lb ip] (http-sendrecv/url resource)))
        (copy-port ip outp)))))


(provide download-music)
