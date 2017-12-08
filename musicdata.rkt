#lang racket

(require net/url)
(require xml)
(require xml/path)

(define feed-url "https://musicforprogramming.net/rss.php")

;; Signature
;; out - (List (Listof String)   -- titles
;;             (Listof String)   -- guids / urls
;;             (Listof String))  -- durations
(define (music-data)
  (define url-port (get-pure-port (string->url feed-url)))
  (define response (read-xml url-port))

  (define expr (xml->xexpr (document-element response)))

  (define guids (se-path*/list '(channel item guid) expr))
  (define titles (se-path*/list '(channel item title) expr))
  (define durations (se-path*/list '(channel item itunes:duration) expr))

  (list titles
        guids
        durations))


(provide music-data)
