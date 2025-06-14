;; Skill Endorsements Contract
;; Enables users to endorse each other's skills on-chain.

;; Constants
(define-constant err-already-endorsed (err u100))

;; Map to store endorsements: (endorsed, skill) => list of endorsers
(define-map endorsements (tuple (endorsed principal) (skill (string-ascii 32))) (list 100 principal))

;; Endorse a colleague for a skill
(define-public (endorse (user principal) (skill (string-ascii 32)))
  (let (
        (key (tuple (endorsed user) (skill skill)))
        (existing (default-to '() (map-get? endorsements key)))
      )
    (begin
      ;; Ensure endorser hasn't already endorsed for this skill
      (asserts! (is-none (iter-find? (lambda (e) (is-eq e tx-sender)) existing)) err-already-endorsed)
      (map-set endorsements key (cons tx-sender existing))
      (ok true))))

;; Get all endorsers for a user’s skill
(define-read-only (get-endorsers (user principal) (skill (string-ascii 32)))
  (ok (default-to '() (map-get? endorsements (tuple (endorsed user) (skill skill))))))
