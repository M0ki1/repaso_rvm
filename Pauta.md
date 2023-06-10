# Pauta

Hoy dia vamos hacer esto en base a la metodologia **AGILE**. La metodologia agile tepermite presentarle cosas al cliente mas rapido, hacer una funcionalidad completa consus vistas, controladores, modelas.

# Primer paso.
* Criar una base.
* definir el layout de la base.
* Crear modelo de User con Device.
* Crear tabla y modelo para Tweet.

# Paso a paso

1. para crear algo con bootstrap se corre `$ rails new simple_twitter --database postgresql -j esbuild --css bootstrap`

2. Vamos a probar altiro bootstrap por que si no pa que, para crear una nueva vista tenemos que crear un nuevo controlador.

3. Primero agregamos la ruta `root "static_pages#home"`

4. Agregamos ahora el controlador static_pages donde hacemos la home
5. ahora con esto lo que haremmos sera crear una carpeta en views con el mismo nombre del controlador.
6. dentro de esta carpeta, creamos un home.html.erb
   
7. para el nav bar creamos en las views/layouts un _navbar.html.erb
8. en application.html.erb que esta en layouts hacemos un <%= render partial "layouts/navbar">
   
9. Despues corremos bundle add cssbundling-rails
    ```bash 
    ./bin/rails css:install:bootstrap
    yarn build:css
    yarn add @hotwired/turbo-rails
    yarn add @hotwired/stimulus
    yarn```

## YA MUCHOS PRIMEROS PASOS, HAGAMOS QUE FUNCION EL NAVBAR

1. al nombre de la marca, le agrego el siguiente link:

```erb
<%= link_to "sTwitter", root_path, class:"navbar-brand"%>
```

2. Borramos el dropdown y el disable
3. Generamos los links

---

Vamos a usar el **git flow**

```bash
git checkout -b feature/agregar-modelo-con-usuario-rails
```
creamos otra rama par esto.

1. Como vamos a crear el usuario tenemos que agregar la gem de **devise**. para esto corremos 
   ```bash
   bundle add devise
   bundle install
   bin/rails g devise:install
   ```

2. Creamos dentro un patial con los flash message, en un _flash.html.erb  y le agregamos la logica de que los muestre cuando existan:

```erb

<%if notice%>
<div class="alert alert-success" role="alert">
  <%= notice%>
</div>
<%end%>

<%if alert%>

<div class="alert alert-danger" role="alert">
  <%= alert %>
</div>
<%end%>

```

3. Ahora rendereamos esa partial en la vista de application.html.erb
   
```erb
<%=render partial: "layouts/flash"%>
```

4. Crearemos el modelo usuario de la siguiente forma

```bash
$ rails g devise User
```

Esto nos genera una migracion, modelos y algo mas.

5. A la migracion que nos genero le vamos a agregar la siguientes cosas:
   
```rb
 t.string :first_name, null: false, default: ""
 t.string :last_name, null: false, default: ""
```

6. Ahora corremos 
```rb
 bin/rails db:migrate
```
Si queremos correr de nuevo la ultima migracion por que la editamos corremos: 
```rb
 bin/rails db:migrate:redo
```

7. Ahora en el modelo de usuario tenemos que validar tambien que *last_name* y *first_name* sean **true**:
(*app/models/user.rb*). Se suele hacer esto porque hacer consultas a la bdd es un cacho en general y lento.
```rb
validates :first_name, presence: true
validates :last_name, presence: true
```

8. Como nosotros queremos validar todo esto, tenemos que agergar un par de cosas a estos lados. Como queremos que el usario se valide antes de hacer cualquier cosa tenemos que añadirle el siguiente comando, esto lo hacemos en: *app/controllers/application_controller.rb*

```rb
  before_action :authenticate_user!
```

9. Vamos a querer que tenga unas vistas bonitas asi que corremos

```bash 
  rails generate devise:views
```
Esto nos genera las vista de devise para que podamos cambiarlas.
10. Poquito de Bootstrap es que las row son laterales y se mueven en 12 y yo le puedo decir cuanto use estas. BASICAMENTE EL SISTEMA DE GRILLAS FLACO.

11. Le vamos a meter un poquito de bootrstrap a este tema de la nueva sesión, pondre solo el resultado final. *app/views/devise/sessions/new.html.erb*

```html
<div class="container">
  <h2>Log in</h2>
  <%= form_for(resource, as: resource_name, url: session_path(resource_name)) do |f| %>
  <div class = "form-row">
   <div class="form-group col-6">  <!--esto es por que me lo pide bootstrap para los inputs -->
    <%= f.label :email%><br />
    <%= f.email_field :email, autofocus: true, autocomplete: "email",class:"form-control"  %>
    </div>
  
  </div>
  
<div class="form-row">
  <div class="form-group col-6">
    <%= f.label :password %><br />
    <%= f.password_field :password, autocomplete: "current-password",class:"form-control" %>
  </div>
</div>

  <% if devise_mapping.rememberable? %>
    <div class="form-check">
      <%= f.check_box :remember_me,class:"form-check-input" %>
      <%= f.label :remember_me,class:"form-check-label" %>
    </div>
  <% end %>

  <div class="actions">
    <%= f.submit "Log in",class:"btn btn-primary" %>
  </div>
  <% end %>

  <%= render "devise/shared/links" %>

</div>
```
12. Lo mismo pero para cosas de registro que estan en *app/views/devise/registrations/new.html.erb*

```html
<div class="container">
  <h2>Sign up</h2>

  <%= form_for(resource, as: resource_name, url: registration_path(resource_name)) do |f| %>
    <%= render "devise/shared/error_messages", resource: resource %>
    <div class="form-row">
      <div class="form-group col-6">
        <%= f.label :email %><br />
        <%= f.email_field :email, autofocus: true, autocomplete: "email",class:"form-control" %>
      </div>
    </div>

    <div class="form-row">
      <div class="form-group col-6">
        <%= f.label :first_name %><br />
        <%= f.text_field :first_name, autofocus: true, autocomplete: "nombre",class:"form-control" %>
      </div>
    </div>

      <div class="form-row">
      <div class="form-group col-6">
        <%= f.label :last_name %><br />
        <%= f.text_field :last_name, autofocus: true, autocomplete: "nombre",class:"form-control" %>
      </div>
    </div>
    
    
    <div class="form-row">
      <div class="form-group col-6">
        <%= f.label :password %>
        <% if @minimum_password_length %>
        <em>(<%= @minimum_password_length %> characters minimum)</em>
        <% end %><br />
        <%= f.password_field :password, autocomplete: "new-password",class:"form-control" %>
      </div>
    </div>
   
    <div class="form-row">
      <div class="form-group col-6">
        <%= f.label :password_confirmation %><br />
      <%= f.password_field :password_confirmation, autocomplete: "new-password",class:"form-control" %>
      </div>
    </div>
   

    <div class="actions">
      <%= f.submit "Sign up",class:"btn btn-primary" %>
    </div>
  <% end %>

  <%= render "devise/shared/links" %>
</div>
```
13. Esta wea se cae por que devise no tiene estos campos de ***first_name*** y ***last_name*** entonces que agregarle esta cosa mediante Strong Parameters porque no reciven estas cosas asi que tenemos que agregarle distintas cosas asi que en application_controller hacemos lo siguiente: *app/controllers/application_controller.rb*

```rb
before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name,:last_name])

  end
```

14.  Vamos a agregar un boton para salir deslogearte entonces en el navbar agregamos dentro del tag `<ul>`:

```erb
<%if user_signed_in?%>
    <li class="nav-item">
        <%= button_to "Log Out", destroy_user_session_path, method: :delete, class:"btn btn-danger" %>
    </li>
<%end%>

```

# FINALMENTE TWITTER 2

Un tweet en si no es nada mas que un pinche text, nosotros tenemos actualmente el modelo **User** y tenemos que crear un modelo Tweet

1. Creemos la tabla Tweet mediante las migraciones 
```bash
rails g migration AddTweet
```

Ahora a eso generado tenemos que crear la tabla. añadimos cada esto a la migracion:
```rb
create_table :tweets do |t|
      
    t.string :body, null: false, default:""
    t.references :user, foreign_key: true
    t.timestamps
end
```

y corremos la migracion.

2. Crearemos ahora el modelo llamado *tweet.rb*
3. Agregamos las relaciones en *tweet.rb*
```rb
belongs_to :user
```
4. Agregamos las relaciones en *user.rb*
```rb
  has_many :tweets

```


## AHORA HAREMOS EL CRUD DE TWEET
Es importante notar que vamos a armar el crud pensando que si pueden ***borrarlos*** pero no *editarlos*

Tenemos que hacer:

* Index
* Show
* Create
* Destroy
* No hay update por lo que dijimos

1. Creamos en la ruta los resoruces:
   
```rb
 resources :tweets,except: [:update,:edit]
```

creamos  ahor el controlador llamado  *tweets_controller.rb*

```rb
class TweetsController < ApplicationController
    def index
    end
end

```
2. Ahora creamos la carpeta **tweets** en las **views** y generamos el ***index.html.erb***. (*app/views/tweets/index.html.erb*)

3. Ahora creamos una query dentro de el *metodo **index***, recordar que para usar algo en las vistas tenemos que hacer @variable.
```rb
@tweets = Tweet.all
```

4. Ahora tenemos que iterrar esta variable y para cada una generar un partial llamado *_tweet.html.erb* (esta demas decir que es en la carpeta views/tweets)

5. Hay una forma sencilla de renderear estas cosas, esto hace que para cada elemento se genera algo más bonito
```erb
<%= render partial: "tweet",collection: @tweets%>

```
6. Para usar **cada elemento** las collections en el partial, literalmente siempre va a ser el singular de la coleccion
7. Ahora, el modelo usuario deberia de saber como imprimirse por lo que en el modelo definimos una nueva funcion llamada **full_name**: (*app/models/user.rb*)

```rb
  def full_name
    "#{first_name} #{last_name}"
  end
```
8. Para el partial actualmente nos robamos una quote de bootstrap:
```erb
<div class="container mt-3">

    <div class="card">
        <div class="card-header">
            <!-- Esta wea es una aberración, las vistas no deberian tomar clases -->
        <%=tweet.user.full_name%>
        </div>
        <div class="card-body">
        <blockquote class="blockquote mb-0">
            <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer posuere erat a ante.</p>
            <footer class="blockquote-footer">Someone famous in <cite title="Source Title">Source Title</cite></footer>
        </blockquote>
        </div>
    </div>
</div>

```
Como se puede ver, se usa la funcion **user.full_name** que nos imprime el n**ombre completo del usuario dentro de este tweet como titulo**.

9. Ahora lo que se cambia es para poner el body que va de la siguiente manera:

```erb
<blockquote class="blockquote mb-0">
            <p><%=tweet.body%></p>
            <footer class="blockquote-footer">Someone famous in <cite title="Source Title">Source Title</cite></footer>
</blockquote>
```

10. Ahora nuevamente lo que cambiamos es para agregar la fecha:
```erb
<p><%=tweet.body%></p>
<footer class="blockquote-footer"><%=tweet.created_at%></footer>

```
11. Ahora lo que vamos va a ser un parseo de la fecha por que se ve fea la wea po.
*app/models/tweet.rb*
```rb
def creation_date
        created_at.strftime("%e %b %Y")
end
```
Y cambiamos el index tambien para que llame ***creation_date***

```erb
<footer class="blockquote-footer"><%=tweet.creation_date%></footer>
```

### Con esta wea creada nos vamos a hacer el show mi pana
Para esto creamos en el controlador de tweet la siguiente funcion:

```rb
def show
        @tweet = params[:id]
end
```

12. Creamos la vista tambien llamada show.html.erb y reciclamos, esto tiene un tema ya que desde el show hay que cambiarl el render pasandole las cosas
*app/views/tweets/show.html.erb*
```erb
<%= render partial: "tweet", locals:{tweet:@tweet} %>
```
13. Le agregamos un boton para ir al show del tweet en el partial.
   *app/views/tweets/_tweet.html.erb*
```erb
<%= link_to "Ver", tweet, class:"btn btn-primary"%>
```

14. Ahora cambiamos el **navbar** para que nos lleve a tweet_paths
*app/views/layouts/_navbar.html.erb*

```erb
<%= link_to "Home", tweets_path, class:"nav-link active"%>
```

### Vamos por la creación de el tweet

Hay que recordar que esto tiene dos cosas, uno es el formulario y el otro es para guardar las cosas.

1. Crear el formulario vacio con el controlador y el metodo new

```rb
def def new
    @tweet = Tweet.new
end
```
2. creamos la vista new.html.erb y hacemos el siguiente form
   
```erb
<div class="container">
    <h1>New Tweet</h1>
    <div class="form-row">
        <div class="form-group col-6">
            <%=form_with model: @tweet do |f|%>
                <%=f.text_field :body,placeholder:"Comparte tu estado",class:"form-control"%>
                <%=f.submit "Guardar",class:"btn btn-primary mt-4"%>
            <%end%>
        </div>
    </div>
</div>
```

3. Ahora creamos el metodo create en el controlador de tweets junto con un metodo privado para filtrar parametros: adicionalmente chequeamos que sea 

```rb
def create
    puts "LLEGUE"

    tweet = Tweet.new tweet_params
    tweet.user = current_user
    if tweet.save
        redirect_to tweet,notice: "Tweet guardado con exito"    
    else
        render :new
    end
end

private

def tweet_params
    params.require(:tweet).permit(:body)
end
```

4. Finalmente para el delete creo el metodo en el controlador
```rb
def destroy
        puts"hola"
        tweet = Tweet.find params[:id]
        tweet.destroy
        redirect_to tweets_path, notice:"Tweet eleiminado con exito"

    end
```

y tambien creamos un button_to en el _tweet.html.erb para eliminar

```erb
    <%= button_to "Eliminar", tweet,method: :delete, class:"btn btn-danger mt-2"%>
```

IMPORTARTE USAR EL "METHOD: :DELETE por que si no se hace UN GET EN VEZ DE UN DELETE


## VAMOS POR LOS HASTAGS CHILE

Tenemos un user que tiene tweets y vamos a tener ***Hastags*** y esto es una cosa mucho a muchos Hastaga es la palabra como tal y Tag es la tabla que los relaciona lmao.

1. Creemos migraciones.
```
bin/rails g migration AddHashtag

```

2. ahora en lamigracion hacemos
```rb
def change
    create_table :hashtags do |t|
      t.string :name, null: false, default: ""
    
      t.timestamps
    end
    
  end

```
3. La de tags
```
bin/rails g migration AddHastag
```
4. Hay en esa migracion hacemos

```rb
def change
    create_table :tags do |t|
      t.references :tweet, foreign_key: true
      t.references :hashtag, foreign_key: true
    
      t.timestamps
    end
    
  end

```

5. Hay que crear el controlador tag.rb
```rb
class Tag <ApplicationRecord
    belongs_to :hashtag
    belongs_to :tweet
end

```

hashtag tambien
```rb
    has_many :tags
```
tweet tambien
```rb
    has_many :tags
```
6. Ahora como le agrego hashtags a los tweets tenemos que hacerlo en el new. Como la tabla de tweet solo tiene body y como fue creado con form_with *model* no le podemos poner cosas que no vengan de ahí si no la wea paniquea. El modelo y la clase tweet estan mapeadas uno a uno. Yo puedo agregar atributos al modelo que no estan en la tabla lol. Al momento de hacer un punto save estas van a ser borradas
7. Creemos un campo para almacenar esto en el modelo de tweet:
```rb
    attribute :hashtags

```

con eso en el form with you puedo usar el form with con parametros como hashtag.

```erb
<div class="form-group col-6">
            <%= form_with model: @tweet do |f|%>
                <%= f.text_field :body, placeholder:"Comparte tu estado", class:"form-control"%>
                <%= f.text_field :hashtags, placeholder:"hashtags", class:"form-control"%>
                
                <%= f.submit "Guardar",class:"btn btn-primary mt-4"%>
            <% end %>
        </div>

```

Ahora con todo esto que tenemos acá, vamos a ocupar un ***callback*** para poder unirlo con nuestros tags. Tenemos que hacer esto una vez que ya esta guardado. **after_create** o **after_save** Esto lo haremos en el controlador de tweet

```rb
    attribute :hashtags
def create_tags
        # debugger
        hashtags.split(",").each do |h|
            hashtag = Hashtag.find_or_create_by name: h
            Tag.create(tweet: self, hashtag:hashtag)
    end

end

```
Con esto listo ahora queremos mostrar los tweets en el partial de _tweets.erb

```erb
            <footer class="blockquote-footer"><%=tweet.list_hashtags%></footer>


```

Ahora en el model Tweet tenemos que crear la funcion ***list_hashtags***. Usaremos una funcion map de la siguiente manera en el controlador.

```rb
def list_hashtags
    tags.map{|t| t.hashtag.name}.join(",")
end
```