# Z3-http

Z3-http is a small http wrapper written around z3 in go.

## Usage

You can start the server by running `docker run --rm -it -p "8001:80" evdb/z3-http`. This will start the z3-http server on port 8001 on your local machine.

Send a POST request with your input for the z3 command, for example:

```
(declare-const a Int)
(declare-fun f (Int Bool) Int)
(assert (> a 10))
(assert (< (f a true) 100))
(check-sat)
(get-model)
```

The response should be something like:

```
sat
(model
  (define-fun a () Int
    11)
  (define-fun f ((x!0 Int) (x!1 Bool)) Int
    (ite (and (= x!0 11) (= x!1 true)) 0
      0))
)
```

