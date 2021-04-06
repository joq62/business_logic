{application, balcony,
 [{description, " balcony"},
  {vsn, "1.0.0"},
  {modules, [balcony_app,
             balcony_sup,
	     db_balcony,
	     balcony]},
  {registered, [balcony]},
  {applications, [kernel, stdlib]},
  {mod, {balcony_app, []}}
 ]}.
