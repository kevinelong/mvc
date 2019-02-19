#
# Define an MVC(Model View Controller) "Framework" using  three data and content free classes.
#

class Model
  attr_accessor :data

  def initialize(data = {})
    @data = data
  end
end

class View
  def initialize(content = '')
    @content = content
  end

  def render(url, models)
    output = @content
    models.each do |name, model|
      model.data.each do |property, value|
        output = output.gsub('{' + name.to_s + '.' + property.to_s + '}', value)
      end
    end
    output
  end
end

class Controller
  def initialize(routes = {})
    @routes = routes
  end

  def render(url)
    if @routes.key?(url)
      route = @routes[url]
      view = route[:view]
      models = route[:models]
      puts view.render(url, models)
    end
  end
end

#
# Define Views and Models to be mixed together later upon request.
#

home_view = View.new('Welcome to the Home Page.')

greeting_view = View.new('Hello {user.first}, {user.last}. Welcome to {location.name}!')

user_model = Model.new({:first => 'Kevin', :last => 'Long'})
school_model = Model.new({:name => 'the Flatiron-School'})

pooh_model = Model.new({:first => 'Pooh', :last => 'Bear'})
location_model = Model.new({:name => 'the 100 acre wood'})

#
#define a map of URL paths and how they correspond to
#

routes = {

    '/' => {
        :view => home_view,
        :models => {}
    },
    '/greet/' => {
        :view => greeting_view,
        :models => {
            :user => user_model,
            :location => school_model

        }
    },

    '/greet/funny/' => {
        :view => greeting_view,
        :models => {
            :user => pooh_model,
            :location => location_model

        }
    }

}

#
# Simulate client calls to a web server by passing in various test URL paths to a new application/controller instance.
#
app = Controller.new(routes)

app.render('/')
app.render('/greet/')
app.render('/greet/funny/')

#
# Expected output
#
# Welcome to the Home Page.
# Hello Kevin, Long. Welcome to the Flatiron-School!
# Hello Pooh, Bear. Welcome to the 100 acre wood!