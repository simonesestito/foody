package com.simonesestito.foody.springbackend.rest

import com.simonesestito.foody.springbackend.SpecialQueriesService
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

/**
 * @see [com.simonesestito.foody.springbackend.SpecialQueriesService]
 */
@RestController
@RequestMapping("/api/queries")
class SpecialQueriesController(private val service: SpecialQueriesService) {
    @GetMapping("/")
    fun all() = mapOf(
        "elencoRistoranti" to elencoRistoranti(),
        "managerEmail" to managerEmail(),
        "incassoMaxOrdini" to incassoMaxOrdini(),
        "licenziatiGrandiRistoranti" to licenziatiGrandiRistoranti(),
        "aperturaTanteCategorie" to aperturaTanteCategorie(),
        "giornoMaxAperturaPiuCategorie" to giornoMaxAperturaPiuCategorie(),
        "ristorantiMaxProdotti" to ristorantiMaxProdotti(),
        "mediaValutazioniUtente" to mediaValutazioniUtente(),
        "maxOrdinatiRistorante" to maxOrdinatiRistorante(),
        "viciniSapienzaBuoni" to viciniSapienzaBuoni(),
        "adattoATuttiRistorante" to adattoATuttiRistorante(),
        "riderPiuEfficiente" to riderPiuEfficiente(),
        "riderPiuTempo" to riderPiuTempo(),
        "utenteIndeciso" to utenteIndeciso(),
        "accountSospetti" to accountSospetti(),
    )

    @GetMapping("/elencoRistoranti")
    fun elencoRistoranti() = service.elencoRistoranti()

    @GetMapping("/managerEmail")
    fun managerEmail() = service.managerEmail()

    @GetMapping("/incassoMaxOrdini")
    fun incassoMaxOrdini() = service.incassoMaxOrdini()

    @GetMapping("/licenziatiGrandiRistoranti")
    fun licenziatiGrandiRistoranti() = service.licenziatiGrandiRistoranti()

    @GetMapping("/aperturaTanteCategorie")
    fun aperturaTanteCategorie() = service.aperturaTanteCategorie()

    @GetMapping("/giornoMaxAperturaPiuCategorie")
    fun giornoMaxAperturaPiuCategorie() = service.giornoMaxAperturaPiuCategorie()

    @GetMapping("/ristorantiMaxProdotti")
    fun ristorantiMaxProdotti() = service.ristorantiMaxProdotti()

    @GetMapping("/mediaValutazioniUtente")
    fun mediaValutazioniUtente() = service.mediaValutazioniUtente()

    @GetMapping("/maxOrdinatiRistorante")
    fun maxOrdinatiRistorante() = service.maxOrdinatiRistorante()

    @GetMapping("/viciniSapienzaBuoni")
    fun viciniSapienzaBuoni() = service.viciniSapienzaBuoni()

    @GetMapping("/adattoATuttiRistorante")
    fun adattoATuttiRistorante() = service.adattoATuttiRistorante()

    @GetMapping("/riderPiuEfficiente")
    fun riderPiuEfficiente() = service.riderPiuEfficiente()

    @GetMapping("/riderPiuTempo")
    fun riderPiuTempo() = service.riderPiuTempo()

    @GetMapping("/utenteIndeciso")
    fun utenteIndeciso() = service.utenteIndeciso()

    @GetMapping("/accountSospetti")
    fun accountSospetti() = service.accountSospetti()
}