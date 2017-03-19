library(ggplot2)
library(plyr)
library(dplyr)
library(gapminder)
#install.packages("gapminder")
pop.delta <- gapminder %>%
  select(year, lifeExp, pop) %>%
  mutate(pop_change = 100*((pop - lag(pop)))/pop) %>%
  filter(year > 1952) %>%
  group_by(year) %>%
  summarise(pop_delta = mean(pop_change))


x <- select(gapminder, continent, year, lifeExp, pop)
x2 <- mutate(x, pop_change = 100*((pop - lag(pop)))/pop)
x3 <- filter(x2, year > 1952)
qplot(lifeExp,pop_change, data = x3, color = continent)


df <- gapminder %>%
  mutate(gdpPercap_change = 100*((gdpPercap - lag(gdpPercap)))/gdpPercap) %>%
  mutate(lifeExp_change = 100*((lifeExp - lag(lifeExp)))/lifeExp) %>%
  filter(year > 1952)

qplot(log(gdpPercap),lifeExp,data=df, color = continent)
qplot(gdpPercap,lifeExp,data=df, color = continent)
qplot(log(gdpPercap),lifeExp,data=df, color = year)
qplot(gdpPercap,lifeExp_change, data=df, color=continent)
qplot(lifeExp,lifeExp_change, data=df, color=continent)
qplot(gdpPercap,gdpPercap_change, data=df, color=continent)

qplot(lifeExp, data=(df %>% filter(year > 1952 && year < 1980)), geom="density", fill=continent, alpha=I(.5), 
      main="Distribution of Life Expectancy by Continent", xlab="Life Expectancy", 
      ylab="Density")


ggplot(data=df, aes(lifeExp, group = continent, fill = continent, alpha=0.5)) + geom_histogram(breaks=seq(0, 90, by = 3)) + labs(title="Histogram for Life Expectancy") +
labs(x="Life Expectancy", y="Count")

ggplot(data=df, aes(x=gdpPercap, y=lifeExp_change, color = factor(year))) + geom_point(shape=1) + facet_grid(. ~ continent)
ggplot(data=df, aes(x=gdpPercap_change, y=lifeExp_change, color = factor(year))) + geom_point(shape=1) + facet_grid(. ~ continent) +ylim(-25,25) + xlim(-75,75)

qplot(year, lifeExp, data=df, color = continent)
qplot(log(pop), lifeExp, data=(df %>% filter(year == 1957)), color = continent)

qplot(gdpPercap_change,lifeExp_change,data=df, color = continent)+ylim(-25,25) + xlim(-50,50) + labs(title="Comparing Growth Rates of Life Expectancy and Per-Capita GDP") +
  labs(x="Per-Capita GDP Growth Rate (%)", y="Life Expectancy Growth Rate (%)")

qplot(gdpPercap_change,lifeExp,data=df, color = continent)+ labs(title="Life Expectancy Growth Rate vs. Per-Capita GDP") +
  labs(x="Per-Capita GDP (int. dollars)", y="Life Expectancy Growth Rate (%)")

qplot(gdpPercap_change,lifeExp,data=df_europe, color = country)
