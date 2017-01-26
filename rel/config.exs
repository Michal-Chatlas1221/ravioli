Path.join(["rel", "plugins", "*.exs"])
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
    default_release: :default,
    default_environment: :prod

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"q[~BfOBL,fro]XykCVyq^OPZ$*KrFo46aLb5CFw5ks!x!)@X`Xi4mIVBP9@|Cy]N"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"my7FWNu3d[;X)![Kp$hnY5mh@n=hxfYPuD4Dq>qNsx@i8VF4X}}gxO2C&HOaAhT<"
end

release :ravioli do
  set version: "0.1.0"
  set applications: [
    ravioli_cook: :permanent,
    ravioli_shop: :permanent
  ]
end
