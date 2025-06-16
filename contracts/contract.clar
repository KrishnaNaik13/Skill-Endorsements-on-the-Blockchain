(define-map endorsements
  {user: principal}     ;; key: user being endorsed
  {count: uint})        ;; value: number of endorsements

(define-constant err-self-endorse (err u100))

;; Public Function: Endorse another user's skill
(define-public (endorse (recipient principal))
  (begin
    (asserts! (is-eq tx-sender recipient) err-self-endorse)
    (let ((current (default-to u0 (get count (map-get? endorsements {user: recipient})))))
      (map-set endorsements {user: recipient} {count: (+ current u1)}))
    (ok true)))

;; Read-Only Function: Get number of endorsements for a user
(define-read-only (get-endorsements (user principal))
  (let ((entry (map-get? endorsements {user: user})))
    (ok (match entry
         val (some {count: (get count val)})
         none))))
