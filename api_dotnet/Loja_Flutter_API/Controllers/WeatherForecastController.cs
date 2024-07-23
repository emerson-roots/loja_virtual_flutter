using Microsoft.AspNetCore.Mvc;

namespace Loja_Flutter_API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class WeatherForecastController : ControllerBase
    {
        private static readonly string[] Summaries = new[]
        {
            "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
        };

        private readonly ILogger<WeatherForecastController> _logger;

        public WeatherForecastController(ILogger<WeatherForecastController> logger)
        {
            _logger = logger;
        }

        [HttpGet(Name = "GetWeatherForecast")]
        public async Task<IActionResult> Get()
        {

            try
            {

                _logger.LogInformation("Info: LOG - Recuperando dados no endpoint GetWeatherForecast...");

                if (new Random().Next(0, 3) == 1)
                    throw new Exception("Erro induzido para testes...");


                var result = Enumerable.Range(1, 5).Select(index => new WeatherForecast
                {
                    Date = DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
                    TemperatureC = Random.Shared.Next(-20, 55),
                    Summary = Summaries[Random.Shared.Next(Summaries.Length)]
                })
                .ToArray();

                return Ok(result);
            }
            catch (Exception ex)
            {
                string message = $"Ocorreu um erro: {ex.Message}";
                _logger.LogError(ex.ToString());
                return StatusCode(500, message);
            }

        }
    }
}
